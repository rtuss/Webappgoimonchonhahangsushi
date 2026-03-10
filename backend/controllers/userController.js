import User from "../models/user.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

// Đăng ký user mới
export const registerUser = async (req, res) => {
  try {
    // Hỗ trợ cả hai format từ frontend và API cũ
    const { tenDangNhap, matKhau, email, hoTen, vaiTro, fullName, password, role, phone } = req.body;

    // Dùng giá trị từ frontend nếu có, nếu không dùng giá trị API cũ
    const finalEmail = email || '';
    const finalPassword = matKhau || password || '';
    const finalName = hoTen || fullName || '';
    const finalRole = vaiTro || role || 'staff';
    const finalUsername = tenDangNhap || (email ? email.split('@')[0] : '');
    const finalPhone = phone || '';

    // Kiểm tra các tham số có tồn tại không
    if (!finalUsername || !finalPassword || !finalEmail || !finalName) {
      return res.status(400).json({ message: "Vui lòng cung cấp đủ thông tin (username, password, email, name)!" });
    }

    // Kiểm tra user đã tồn tại chưa (bằng email hoặc username)
    const existingUser = await User.findOne({ 
      $or: [{ tenDangNhap: finalUsername }, { email: finalEmail }] 
    });
    if (existingUser) {
      return res.status(400).json({ message: "Email hoặc tên đăng nhập đã tồn tại" });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(finalPassword, 10);

    const newUser = new User({
      tenDangNhap: finalUsername,
      matKhau: hashedPassword,
      email: finalEmail,
      hoTen: finalName,
      vaiTro: finalRole,
      phone: finalPhone,
    });

    await newUser.save();
    console.log('✅ User created:', finalEmail);

    res.status(201).json({ 
      message: "Tạo user thành công!",
      user: {
        _id: newUser._id,
        email: newUser.email,
        fullName: newUser.hoTen,
        role: newUser.vaiTro,
        phone: newUser.phone
      }
    });
  } catch (error) {
    console.error('❌ Register error:', error.message);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Đăng nhập user
export const loginUser = async (req, res) => {
  try {
    const { tenDangNhap, matKhau } = req.body;

    const user = await User.findOne({ tenDangNhap });
    if (!user) return res.status(400).json({ message: "Sai tên đăng nhập hoặc mật khẩu" });

    const isMatch = await bcrypt.compare(matKhau, user.matKhau);
    if (!isMatch)
      return res.status(400).json({ message: "Sai tên đăng nhập hoặc mật khẩu" });

    // Tạo JWT
    const token = jwt.sign(
      { id: user._id, role: user.vaiTro },
      process.env.JWT_SECRET || "default_secret",
      { expiresIn: "7d" }
    );

    res.json({
      message: "Đăng nhập thành công",
      token,
      user: {
        id: user._id,
        tenDangNhap: user.tenDangNhap,
        vaiTro: user.vaiTro,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Lấy danh sách người dùng
export const getUsers = async (req, res) => {
  try {
    const users = await User.find().select('-matKhau').lean(false);  // lean(false) to enable toJSON transform
    console.log('📊 getUsers: Returning', users.length, 'users');
    
    // Ensure fullName and role are mapped
    const mappedUsers = users.map(user => ({
      _id: user._id,
      email: user.email,
      fullName: user.fullName || user.hoTen || 'N/A',
      phone: user.phone || '',
      role: user.role || user.vaiTro || 'customer',
      tenDangNhap: user.tenDangNhap,
      hoTen: user.hoTen,
      vaiTro: user.vaiTro
    }));
    
    res.json(mappedUsers);
  } catch (error) {
    console.error('❌ getUsers error:', error.message);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Cập nhật thông tin người dùng (cho admin dashboard)
export const updateUser = async (req, res) => {
  const { id } = req.params;
  const { email, fullName, phone, role, password } = req.body;

  try {
    console.log('📝 updateUser called with id:', id);
    console.log('📋 Payload:', { email, fullName, phone, role });
    
    const updateData = {
      email,
      fullName,
      phone,
      role: role || 'staff',
      hoTen: fullName,  // Map to Vietnamese field
      vaiTro: role || 'staff'
    };

    // Nếu có password mới, hash nó
    if (password) {
      console.log('🔐 Password provided, hashing...');
      updateData.matKhau = await bcrypt.hash(password, 10);
    }

    const user = await User.findByIdAndUpdate(id, updateData, { new: true }).select('-matKhau');
    
    if (!user) {
      console.error('❌ User not found:', id);
      return res.status(404).json({ message: "Không tìm thấy người dùng" });
    }

    console.log('✅ User updated:', email);
    res.json({ message: "Cập nhật người dùng thành công", user });
  } catch (error) {
    console.error('❌ updateUser error:', error.message);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Cập nhật vai trò người dùng
export const updateUserRole = async (req, res) => {
  const { id } = req.params;
  const { vaiTro } = req.body;

  try {
    const user = await User.findByIdAndUpdate(id, { vaiTro }, { new: true });
    if (!user) {
      return res.status(404).json({ message: "Không tìm thấy người dùng" });
    }
    res.json({ message: "Cập nhật vai trò thành công", user });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Xóa người dùng
export const deleteUser = async (req, res) => {
  const { id } = req.params;

  try {
    console.log('🗑️  Deleting user:', id);
    const deletedUser = await User.findByIdAndDelete(id);
    if (!deletedUser) {
      console.error('❌ User not found:', id);
      return res.status(404).json({ message: "Người dùng không tìm thấy" });
    }

    console.log('✅ User deleted:', deletedUser.email);
    res.json({ message: "Người dùng đã được xóa", user: deletedUser });
  } catch (err) {
    console.error('❌ deleteUser error:', err.message);
    res.status(500).json({ message: "Không thể xóa người dùng", error: err.message });
  }
};

export default { registerUser, loginUser, getUsers, updateUser, updateUserRole, deleteUser };
