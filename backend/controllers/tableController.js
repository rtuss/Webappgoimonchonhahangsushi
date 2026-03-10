import Ban from "../models/Ban.js";
import DonHang from "../models/DonHang.js";

// 📋 Lấy tất cả bàn với trạng thái từ orders
export const getTables = async (req, res) => {
  try {
    const bans = await Ban.find().sort({ soBan: 1 });
    
    // Lấy tất cả đơn hàng chưa hoàn tất
    const activeOrders = await DonHang.find({
      trangThai: { $nin: ['hoan_tat', 'huy'] }
    });

    // Gán trạng thái based on orders
    const bansWithStatus = bans.map(ban => {
      const banOrder = activeOrders.find(o => o.soBan === ban.soBan);
      return {
        ...ban.toObject(),
        trangThai: banOrder ? 'dang_su_dung' : 'trong'
      };
    });

    res.json({
      success: true,
      data: bansWithStatus
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi lấy danh sách bàn',
      error: error.message
    });
  }
};

// ➕ Tạo bàn mới
export const createTable = async (req, res) => {
  try {
    const { soBan, tenBan, viTri, sucChua, ghiChu } = req.body;

    if (!soBan || soBan < 1 || soBan > 99) {
      return res.status(400).json({
        success: false,
        message: 'Số bàn không hợp lệ (1-99)'
      });
    }

    const existing = await Ban.findOne({ soBan });
    if (existing) {
      return res.status(400).json({
        success: false,
        message: `Bàn số ${soBan} đã tồn tại`
      });
    }

    const newBan = new Ban({
      soBan,
      tenBan: tenBan || null,
      viTri: viTri || 'Tầng 1',
      sucChua: sucChua || 4,
      trangThai: 'trong',
      ghiChu: ghiChu || ''
    });

    await newBan.save();

    res.status(201).json({
      success: true,
      message: 'Tạo bàn thành công',
      data: newBan
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi tạo bàn',
      error: error.message
    });
  }
};

// ✏️ Cập nhật bàn
export const updateTable = async (req, res) => {
  try {
    const { id } = req.params;
    const { tenBan, viTri, sucChua, ghiChu } = req.body;

    const ban = await Ban.findByIdAndUpdate(
      id,
      {
        tenBan: tenBan !== undefined ? tenBan : undefined,
        viTri: viTri || undefined,
        sucChua: sucChua || undefined,
        ghiChu: ghiChu !== undefined ? ghiChu : undefined
      },
      { new: true }
    );

    if (!ban) {
      return res.status(404).json({
        success: false,
        message: 'Bàn không tồn tại'
      });
    }

    res.json({
      success: true,
      message: 'Cập nhật bàn thành công',
      data: ban
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi cập nhật bàn',
      error: error.message
    });
  }
};

// 🗑️ Xóa bàn
export const deleteTable = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra xem có đơn hàng đang hoạt động không
    const activeOrder = await DonHang.findOne({
      soBan: (await Ban.findById(id))?.soBan,
      trangThai: { $nin: ['hoan_tat', 'huy'] }
    });

    if (activeOrder) {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa bàn có đơn hàng đang hoạt động'
      });
    }

    const ban = await Ban.findByIdAndDelete(id);

    if (!ban) {
      return res.status(404).json({
        success: false,
        message: 'Bàn không tồn tại'
      });
    }

    res.json({
      success: true,
      message: 'Xóa bàn thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi xóa bàn',
      error: error.message
    });
  }
};
