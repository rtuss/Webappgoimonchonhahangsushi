import TinNhan from "./models/Message.js";

let io_instance = null; // Lưu instance io để broadcast từ API

export function initChatSocket(io) {
  io_instance = io; // Lưu để dùng trong routes
  
  io.on("connection", (socket) => {
    console.log("🟢 User joined:", socket.id);

    // join room theo số bàn
    socket.on("joinRoom", (banId) => {
      socket.join("ban_" + banId);
      console.log(`🔵 Socket ${socket.id} joined room ban_${banId}`);
    });

    // leave room khi user chuyển bàn
    socket.on("leaveRoom", (banId) => {
      socket.leave("ban_" + banId);
      console.log(`⚫ Socket ${socket.id} left room ban_${banId}`);
    });

    // nhận tin nhắn từ client
    socket.on("sendMessage", async (msg) => {
      try {
        // CHUẨN HÓA ENUM
        const fixedSender =
          msg.nguoiGui === "staff" || msg.nguoiGui === "nhan_vien"
            ? "nhanvien"
            : "khach";

        const data = {
          banId: msg.banId,
          noiDung: msg.noiDung,
          nguoiGui: fixedSender,
          thoiGian: msg.thoiGian || new Date(),
        };

        const saved = await TinNhan.create(data);

        // Emit cho client khác trong phòng (không gửi lại cho người gửi)
        socket.broadcast.to("ban_" + msg.banId).emit("receiveMessage", saved);
        
        // Gửi xác nhận cho người gửi
        socket.emit("messageSent", { success: true, messageId: saved._id });
      } catch (err) {
        console.log("🔥 Lỗi lưu tin nhắn:", err);
      }
    });
  });
}

// Export function để gọi từ routes khi menu thay đổi
export function broadcastMenuUpdate(action, menuItem) {
  if (io_instance) {
    io_instance.emit("menuUpdated", {
      action, // 'add', 'update', 'delete'
      menuItem,
      timestamp: new Date()
    });
    console.log(`📢 Broadcast menu ${action}:`, menuItem?.tenMon);
  }
}

// Export function để broadcast khi đơn hàng thay đổi
export function broadcastOrderUpdate(action, order) {
  if (io_instance) {
    // Broadcast cho tất cả clients
    io_instance.emit("orderUpdated", {
      action, // 'new', 'status_changed', 'deleted'
      order,
      timestamp: new Date()
    });
    
    // Broadcast cho phòng chat cụ thể nếu order có soBan
    if (order?.soBan) {
      io_instance.to("ban_" + order.soBan).emit("orderUpdated", {
        action,
        order,
        timestamp: new Date()
      });
    }
    
    console.log(`📢 Broadcast order ${action}:`, order?._id);
  }
}
