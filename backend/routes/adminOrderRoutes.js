import express from "express";
import axios from "axios";
import { auth } from "../Middleware/authMiddleware.js";
import DonHang from "../models/DonHang.js";
import { broadcastOrderUpdate } from "../chat-socket.js";

const router = express.Router();

// LẤY TẤT CẢ ĐƠN - GET /api/admin/orders
router.get("/", auth, async (req, res) => {
  try {
    console.log('📦 Fetching all orders');
    const orders = await DonHang.find()
      .populate("danhSachMon.monAn")
      .sort({ thoiGianDat: -1 });

    console.log('✅ Found', orders.length, 'orders');
    res.json({ success: true, data: orders });
  } catch (err) {
    console.error('❌ Error fetching orders:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// CẬP NHẬT TRẠNG THÁI - PATCH /api/admin/orders/:id/status
router.patch("/:id/status", auth, async (req, res) => {
  try {
    console.log('🔄 Updating order status:', req.params.id);
    const don = await DonHang.findByIdAndUpdate(
      req.params.id,
      { trangThai: req.body.trangThai },
      { new: true }
    ).populate("danhSachMon.monAn");

    if (!don) {
      return res.status(404).json({ success: false, error: "Đơn hàng không tìm thấy" });
    }

    console.log('✅ Order updated:', req.body.trangThai);
    
    // Broadcast to all connected clients
    broadcastOrderUpdate('status_changed', don);

    // 🧹 Nếu order hoàn tất -> xóa chat lịch sử của bàn
    if (req.body.trangThai === "hoan_tat" && don.soBan) {
      try {
        await axios.delete(`http://localhost:3000/api/chat/${don.soBan}/messages`);
        console.log(`🧹 Cleared chat for bàn ${don.soBan}`);
        
        // 📢 Broadcast chat clear event để frontend reload
        broadcastOrderUpdate("chat_cleared", { soBan: don.soBan });
      } catch (clearErr) {
        console.warn("⚠️ Error clearing chat:", clearErr.message);
      }
    }
    
    res.json({ success: true, data: don });
  } catch (err) {
    console.error('❌ Error updating order:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
