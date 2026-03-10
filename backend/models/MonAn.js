// 📁 backend/models/MonAn.js
import mongoose from "mongoose";

const MonAnSchema = new mongoose.Schema({
  tenMon: { type: String, required: true },         // Tên món ăn
  moTa: { type: String, default: "" },              // Mô tả ngắn
  gia: { type: Number, required: true },            // Giá bán
  loaiMon: { type: String, default: "Khác" },       // Loại món (sushi, sashimi...)
  hinhAnh: { type: String, default: "" },           // Link hình ảnh
  conPhucVu: { type: Boolean, default: true },      // Còn phục vụ không
  giamGia: { type: Number, default: 0 },            // % giảm giá
  danhGia: { type: Number, default: 0 },            // Điểm đánh giá trung bình
  soDanhGia: { type: Number, default: 0 },          // Số lượt đánh giá
});

export default mongoose.model("MonAn", MonAnSchema);

