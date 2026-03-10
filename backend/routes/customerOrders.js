import express from "express";
import DonHang from "../models/DonHang.js";
import { broadcastOrderUpdate } from "../chat-socket.js";

const router = express.Router();

// ===================================================
// KHÁCH HÀNG TẠO ĐƠN - POST /api/orders
// ===================================================
router.post("/", async (req, res) => {
  try {
    console.log("📥 Nhận đơn từ Flutter:", req.body);

    // Tính tổng tiền từ danhSachMon
    let tongTien = 0;
    if (Array.isArray(req.body.danhSachMon)) {
      // Tạm thời để default = 0, sẽ populate sau
      // (thường tính từ MonAn.gia * soLuong)
      tongTien = 0;
    }

    const don = await DonHang.create({
      soBan: req.body.soBan,
      danhSachMon: req.body.danhSachMon,
      tongTien: tongTien,
      trangThai: "cho_xac_nhan",
      thoiGianDat: new Date()
    });

    const donDayDu = await don.populate("danhSachMon.monAn");

    // 💰 Tính lại tongTien dựa trên MonAn.gia
    let totalPrice = 0;
    if (Array.isArray(donDayDu.danhSachMon)) {
      totalPrice = donDayDu.danhSachMon.reduce((sum, item) => {
        const gia = item.monAn?.gia || 0;
        console.log("📊 Item:", item.monAn?.tenMon, "Giá:", gia, "Qty:", item.soLuong, "Subtotal:", gia * item.soLuong);
        return sum + (gia * item.soLuong);
      }, 0);
    }
    console.log("💰 Total Price:", totalPrice);
    donDayDu.tongTien = totalPrice;
    await donDayDu.save();

    // 📢 Broadcast đơn hàng mới cho admin và nhân viên
    broadcastOrderUpdate('new', donDayDu);

    res.status(201).json({
      success: true,
      data: donDayDu
    });
  } catch (err) {
    console.error('❌ Error creating order:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ===================================================
// LẤY ĐƠN THEO BÀN - GET /api/orders/table/:soBan
// ===================================================
router.get("/table/:soBan", async (req, res) => {
  try {
    const orders = await DonHang.find({ soBan: req.params.soBan })
      .populate("danhSachMon.monAn")
      .sort({ thoiGianDat: -1 });

    res.json({ success: true, data: orders });
  } catch (err) {
    console.error('❌ Error fetching orders:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ===================================================
// THÊM MÓN VÀO ĐƠN HIỆN TẠI - PATCH /api/orders/:id/add-mon
// ===================================================
router.patch("/:id/add-mon", async (req, res) => {
  try {
    const { monAnId, soLuong } = req.body;
    
    if (!monAnId || !soLuong) {
      return res.status(400).json({ 
        success: false, 
        error: "❌ Cần monAnId và soLuong" 
      });
    }

    const don = await DonHang.findById(req.params.id);
    if (!don) {
      return res.status(404).json({ 
        success: false, 
        error: "❌ Không tìm thấy đơn hàng" 
      });
    }

    // Kiểm tra xem món đã có trong đơn không
    const existingItem = don.danhSachMon.find(
      item => item.monAn.toString() === monAnId
    );

    if (existingItem) {
      // Nếu có rồi, tăng số lượng
      existingItem.soLuong += parseInt(soLuong);
    } else {
      // Nếu chưa có, thêm mới
      don.danhSachMon.push({
        monAn: monAnId,
        soLuong: parseInt(soLuong),
        ghiChuDacBiet: ""
      });
    }

    // Populate để lấy thông tin món ăn
    const donDayDu = await don.populate("danhSachMon.monAn");

    // Tính lại tổng tiền
    let totalPrice = 0;
    if (Array.isArray(donDayDu.danhSachMon)) {
      totalPrice = donDayDu.danhSachMon.reduce((sum, item) => {
        const gia = item.monAn?.gia || 0;
        return sum + (gia * item.soLuong);
      }, 0);
    }
    donDayDu.tongTien = totalPrice;
    await donDayDu.save();

    // 📢 Broadcast cập nhật cho admin
    broadcastOrderUpdate('update', donDayDu);

    res.json({
      success: true,
      data: donDayDu
    });
  } catch (err) {
    console.error('❌ Error adding mon to order:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ===================================================
// CẬP NHẬT TRẠNG THÁI ĐƠN - PATCH /api/orders/:id/status
// ===================================================
router.patch("/:id/status", async (req, res) => {
  try {
    const { trangThai } = req.body;
    
    if (!trangThai) {
      return res.status(400).json({ 
        success: false, 
        error: "❌ Cần trangThai" 
      });
    }

    const don = await DonHang.findByIdAndUpdate(
      req.params.id,
      { trangThai },
      { new: true }
    ).populate("danhSachMon.monAn");

    if (!don) {
      return res.status(404).json({ 
        success: false, 
        error: "❌ Không tìm thấy đơn hàng" 
      });
    }

    // 📢 Broadcast cập nhật cho admin
    broadcastOrderUpdate('update', don);

    res.json({
      success: true,
      data: don
    });
  } catch (err) {
    console.error('❌ Error updating order status:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ===================================================
// CẬP NHẬT PHƯƠNG THỨC THANH TOÁN - PATCH /api/orders/:id/payment-method
// ===================================================
router.patch("/:id/payment-method", async (req, res) => {
  try {
    const { phuongThucThanhToan } = req.body;
    
    if (!phuongThucThanhToan) {
      return res.status(400).json({ 
        success: false, 
        error: "❌ Cần phuongThucThanhToan (tien_mat | chuyen_khoan | viet_qr)" 
      });
    }

    // Kiểm tra phương thức thanh toán hợp lệ
    const validMethods = ['tien_mat', 'chuyen_khoan', 'viet_qr'];
    if (!validMethods.includes(phuongThucThanhToan)) {
      return res.status(400).json({ 
        success: false, 
        error: `❌ Phương thức thanh toán không hợp lệ. Chỉ hỗ trợ: ${validMethods.join(', ')}` 
      });
    }

    const don = await DonHang.findByIdAndUpdate(
      req.params.id,
      { phuongThucThanhToan },
      { new: true }
    ).populate("danhSachMon.monAn");

    if (!don) {
      return res.status(404).json({ 
        success: false, 
        error: "❌ Không tìm thấy đơn hàng" 
      });
    }

    console.log(`✅ Cập nhật phương thức thanh toán: ${phuongThucThanhToan} cho đơn #${don.soBan}`);

    // 📢 Broadcast cập nhật cho admin
    broadcastOrderUpdate('update', don);

    res.json({
      success: true,
      message: `✅ Đã cập nhật phương thức thanh toán: ${phuongThucThanhToan}`,
      data: don
    });
  } catch (err) {
    console.error('❌ Error updating payment method:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
