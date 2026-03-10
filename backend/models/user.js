import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  tenDangNhap: { type: String, required: true, unique: true },
  matKhau: { type: String, required: true },
  hoTen: String,
  email: String,
  vaiTro: { type: String, enum: ['admin', 'staff', 'customer'], default: 'customer' },
  
  // Fields dùng cho admin dashboard (alias hoặc field riêng)
  fullName: { type: String, default: null },
  phone: { type: String, default: null },
  role: { type: String, default: null }
}, { 
  timestamps: true,
  toJSON: {
    transform(doc) {
      // Map Vietnamese fields to English for frontend
      doc.fullName = doc.fullName || doc.hoTen;
      doc.role = doc.role || doc.vaiTro;
      return doc;
    }
  }
});

export default mongoose.model("NguoiDung", userSchema);
