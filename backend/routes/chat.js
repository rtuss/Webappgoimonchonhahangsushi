// routes/chat.js 
import express from "express";
import TinNhan from "../models/Message.js";

const router = express.Router();

// ===============================
// LẤY DANH SÁCH CUỘC HỘI THOẠI
// ===============================
router.get("/conversations", async (req, res) => {
  try {
    const list = await TinNhan.aggregate([
      {
        $group: {
          _id: "$banId",
          lastMessage: { $last: "$noiDung" },
          lastTime: { $last: "$thoiGian" }
        }
      },
      { $sort: { lastTime: -1 } }
    ]);

    const formatted = list.map((c) => ({
      id: c._id,
      title: "Bàn " + c._id,
      lastMessage: c.lastMessage || ""
    }));

    res.json({ success: true, data: formatted });
  } catch (err) {
    console.error(err);
    res.json({ success: false });
  }
});

// ===============================
// LẤY TIN NHẮN THEO BÀN
// ===============================
router.get("/:banId/messages", async (req, res) => {
  try {
    const list = await TinNhan.find({ banId: req.params.banId }).sort({
      thoiGian: 1
    });
    res.json({ success: true, data: list });
  } catch (e) {
    res.json({ success: false });
  }
});

// ===============================
// LƯU TIN NHẮN (CHUẨN ENUM)
// ===============================
router.post("/:banId/messages", async (req, res) => {
  try {
    // CHUẨN HÓA ENUM
    const fixedSender =
      req.body.nguoiGui === "staff" ||
      req.body.nguoiGui === "nhan_vien" ||
      req.body.nguoiGui === "nhanvien"
        ? "nhanvien"
        : "khach";

    const msg = await TinNhan.create({
      banId: req.params.banId,
      noiDung: req.body.noiDung,
      nguoiGui: fixedSender,
      thoiGian: new Date()
    });

    res.json({ success: true, data: msg });
  } catch (e) {
    console.log(e);
    res.json({ success: false });
  }
});

// ===============================
// XÓA TIN NHẮN THEO BÀN (khi hoàn tất đơn)
// ===============================
router.delete("/:banId/messages", async (req, res) => {
  try {
    await TinNhan.deleteMany({ banId: req.params.banId });
    res.json({ success: true, message: "Đã xóa tất cả tin nhắn của bàn này" });
  } catch (e) {
    console.log(e);
    res.json({ success: false });
  }
});

export default router;
