import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/user.js";  // Model người dùng

const router = express.Router();

// 🟢 Đăng ký
router.post("/register", async (req, res) => {
  const { tenDangNhap, matKhau, email, hoTen, vaiTro } = req.body;  // Thêm vai trò người dùng

  // Kiểm tra tên đăng nhập đã tồn tại chưa
  const existing = await User.findOne({ tenDangNhap });
  if (existing) return res.status(400).json({ message: "Tên đăng nhập đã tồn tại" });

  // Mã hóa mật khẩu
  const hash = await bcrypt.hash(matKhau, 10);

  // Tạo người dùng mới
  const user = new User({
    tenDangNhap,
    matKhau: hash,
    email,
    hoTen,
    vaiTro: vaiTro || "customer"  // Mặc định vai trò là "customer" nếu không có
  });

  await user.save();
  res.json({ message: "Đăng ký thành công" });
});

// 🟢 Đăng nhập
router.post("/login", async (req, res) => {
  try {
    // Hỗ trợ cả email và username
    const { email, tenDangNhap, matKhau, password } = req.body;
    
    const user = await User.findOne({
      $or: [
        { email },
        { tenDangNhap }
      ]
    });
    
    if (!user) {
      return res.status(400).json({ success: false, message: "❌ Người dùng không tồn tại" });
    }

    const isMatch = await bcrypt.compare(password || matKhau, user.matKhau);
    if (!isMatch) {
      return res.status(400).json({ success: false, message: "❌ Mật khẩu sai" });
    }

    // Kiểm tra role
    if (user.vaiTro !== 'admin' && user.vaiTro !== 'staff') {
      return res.status(403).json({ success: false, message: "❌ Bạn không có quyền truy cập" });
    }

    const token = jwt.sign({ id: user._id, role: user.vaiTro }, process.env.JWT_SECRET, { expiresIn: "24h" });

    res.json({ 
      success: true,
      message: "✅ Đăng nhập thành công", 
      data: {
        token, 
        user: {
          _id: user._id,
          email: user.email,
          tenDangNhap: user.tenDangNhap,
          hoTen: user.hoTen,
          vaiTro: user.vaiTro
        }
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

export default router;
