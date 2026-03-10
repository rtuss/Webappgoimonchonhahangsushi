import express from "express";
import axios from "axios";
import DonHang from "../models/DonHang.js";
import { broadcastOrderUpdate } from "../chat-socket.js";

const router = express.Router();

// ===================================================
// NHÂN VIÊN LẤY TẤT CẢ ĐƠN - GET /api/staff/orders
// ===================================================
router.get("/", async (req, res) => {
  try {
    let orders = await DonHang.find()
      .populate("danhSachMon.monAn")
      .sort({ thoiGianDat: -1 });

    // 💰 Ensure tongTien is calculated for each order
    orders = orders.map(order => {
      try {
        if (!order.tongTien || order.tongTien === 0) {
          let totalPrice = 0;
          if (Array.isArray(order.danhSachMon) && order.danhSachMon.length > 0) {
            totalPrice = order.danhSachMon.reduce((sum, item) => {
              try {
                const gia = item?.monAn?.gia || 0;
                const qty = item?.soLuong || 1;
                return sum + (gia * qty);
              } catch (itemErr) {
                console.warn("⚠️ Error calculating item price:", itemErr.message);
                return sum;
              }
            }, 0);
          }
          order.tongTien = totalPrice;
        }
        return order;
      } catch (orderErr) {
        console.warn("⚠️ Error processing order:", orderErr.message);
        return order;
      }
    });

    res.json({ success: true, data: orders });
  } catch (err) {
    console.error("❌ Error fetching orders:", err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ===================================================
// CẬP NHẬT TRẠNG THÁI - PATCH /api/staff/orders/:id/status
// ===================================================
router.patch("/:id/status", async (req, res) => {
  try {
    const don = await DonHang.findByIdAndUpdate(
      req.params.id,
      { trangThai: req.body.trangThai },
      { new: true }
    ).populate("danhSachMon.monAn");

    // 📢 Broadcast order update
    broadcastOrderUpdate("status_changed", don);

    // 🧹 Nếu order hoàn tất -> xóa chat lịch sử của bàn
    if (req.body.trangThai === "hoan_tat" && don.soBan) {
      try {
        await axios.delete(`http://localhost:3000/api/chat/${don.soBan}/messages`);
        console.log(`🧹 Cleared chat for bàn ${don.soBan}`);
        
        // 📢 Broadcast chat clear event để frontend reload
        broadcastOrderUpdate("chat_cleared", { soBan: don.soBan });
      } catch (clearErr) {
        console.warn("⚠️ Error clearing chat:", clearErr.message);
        // Không throw lỗi, chat clear fail không làm ảnh hưởng đến order update
      }
    }

    res.json({ success: true, data: don });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
