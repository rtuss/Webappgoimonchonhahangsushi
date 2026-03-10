// 📁 backend/routes/callStaff.js
import express from "express";
const router = express.Router();

// ✅ API: Gọi nhân viên
router.post("/", async (req, res) => {
  try {
    const { table } = req.body;
    console.log(`📞 Bàn ${table} vừa gọi nhân viên!`);
    res.json({ success: true, message: `Bàn ${table} đã gọi nhân viên` });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

export default router;
