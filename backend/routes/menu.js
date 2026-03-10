import express from "express";
import MonAn from "../models/MonAn.js";
import { broadcastMenuUpdate } from "../chat-socket.js";

const router = express.Router();

/* =========================================================
   ✅ GET: Lấy danh sách tất cả món ăn
   URL: http://localhost:3000/api/menu
   Method: GET
========================================================= */
router.get("/", async (req, res) => {
  try {
    const data = await MonAn.find();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* =========================================================
   ✅ GET: Lấy chi tiết 1 món ăn theo ID
   URL: http://localhost:3000/api/menu/:id
   Method: GET
========================================================= */
router.get("/:id", async (req, res) => {
  try {
    const mon = await MonAn.findById(req.params.id);
    if (!mon) return res.status(404).json({ message: "Không tìm thấy món ăn!" });
    res.json(mon);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* =========================================================
   ✅ POST: Thêm món ăn mới
   URL: http://localhost:3000/api/menu
   Method: POST
========================================================= */
router.post("/", async (req, res) => {
  try {
    const mon = new MonAn(req.body);
    await mon.save();
    
    // 📢 Broadcast thêm menu cho tất cả client
    broadcastMenuUpdate('add', mon);
    
    res.json({ message: "✅ Đã thêm món mới!", mon });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* =========================================================
   ✅ PUT: Cập nhật thông tin món ăn
   URL: http://localhost:3000/api/menu/:id
   Method: PUT
========================================================= */
router.put("/:id", async (req, res) => {
  try {
    const mon = await MonAn.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!mon) return res.status(404).json({ message: "Không tìm thấy món ăn để cập nhật!" });
    
    // 📢 Broadcast cập nhật menu cho tất cả client
    broadcastMenuUpdate('update', mon);
    
    res.json({ message: "✅ Cập nhật thành công!", mon });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* =========================================================
   ✅ PATCH: Cập nhật thông tin món ăn (dùng cho admin)
   URL: http://localhost:3000/api/menu/:id
   Method: PATCH
========================================================= */
router.patch("/:id", async (req, res) => {
  try {
    const mon = await MonAn.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!mon) return res.status(404).json({ message: "Không tìm thấy món ăn để cập nhật!" });
    
    // 📢 Broadcast cập nhật menu cho tất cả client
    broadcastMenuUpdate('update', mon);
    
    res.json({ message: "✅ Cập nhật thành công!", mon });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* =========================================================
   ✅ DELETE: Xóa món ăn
   URL: http://localhost:3000/api/menu/:id
   Method: DELETE
========================================================= */
router.delete("/:id", async (req, res) => {
  try {
    const mon = await MonAn.findByIdAndDelete(req.params.id);
    if (!mon) return res.status(404).json({ message: "Không tìm thấy món ăn để xóa!" });
    
    // 📢 Broadcast xóa menu cho tất cả client
    broadcastMenuUpdate('delete', mon);
    
    res.json({ message: "🗑️ Đã xóa món ăn thành công!" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
