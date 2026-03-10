import mongoose from "mongoose";

const banSchema = new mongoose.Schema({
  soBan: { type: Number, required: true, unique: true },
  tenBan: { type: String, default: null },
  viTri: { type: String, default: "Tầng 1" },
  sucChua: { type: Number, default: 4 },
  trangThai: { 
    type: String, 
    enum: ['trong', 'co_khach', 'sap_co_khach'],
    default: 'trong'
  },
  ghiChu: { type: String, default: "" },
  thoiGianTao: { type: Date, default: Date.now }
});

export default mongoose.model("Ban", banSchema, "banans");
