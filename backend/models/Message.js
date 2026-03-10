import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
  tinNhanId: { type: String },
  noiDung: { type: String, required: true },
  thoiGian: { type: Date, default: Date.now },
  nguoiGui: { type: String, enum: ["khach", "nhanvien"], required: true },
  banId: { type: String, required: true }, // theo sơ đồ class
});

export default mongoose.model("TinNhan", messageSchema);
