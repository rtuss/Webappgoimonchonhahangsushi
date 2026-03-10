import express from "express";
import Ban from "../models/Ban.js";

const router = express.Router();

/* =========================================================
   ✅ GET: Lấy danh sách tất cả bàn
   URL: http://localhost:3000/api/tables
   Method: GET
========================================================= */
router.get("/", async (req, res) => {
  try {
    const tables = await Ban.find().sort({ soBan: 1 });
    res.json(tables);
  } catch (err) {
    res.status(500).json({ 
      success: false,
      error: err.message 
    });
  }
});

/* =========================================================
   ✅ GET: Lấy chi tiết 1 bàn theo ID
   URL: http://localhost:3000/api/tables/:id
   Method: GET
========================================================= */
router.get("/:id", async (req, res) => {
  try {
    const table = await Ban.findById(req.params.id);
    if (!table) {
      return res.status(404).json({ 
        success: false,
        message: "Không tìm thấy bàn!" 
      });
    }
    res.json(table);
  } catch (err) {
    res.status(500).json({ 
      success: false,
      error: err.message 
    });
  }
});

/* =========================================================
   ✅ PATCH: Cập nhật trạng thái bàn
   URL: http://localhost:3000/api/tables/:id
   Method: PATCH
========================================================= */
router.patch("/:id", async (req, res) => {
  try {
    const table = await Ban.findByIdAndUpdate(
      req.params.id, 
      req.body, 
      { new: true }
    );
    if (!table) {
      return res.status(404).json({ 
        success: false,
        message: "Không tìm thấy bàn để cập nhật!" 
      });
    }
    res.json({ 
      success: true,
      message: `✅ Cập nhật bàn ${table.tenBan} thành công!`,
      data: table 
    });
  } catch (err) {
    res.status(500).json({ 
      success: false,
      error: err.message 
    });
  }
});

export default router;
