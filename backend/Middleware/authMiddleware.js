import jwt from "jsonwebtoken";
import User from "../models/user.js";  // Đảm bảo đường dẫn đúng

export const auth = async (req, res, next) => {
  const authHeader = req.header("Authorization");

  if (!authHeader) {
    return res.status(401).json({ message: "Không có token, quyền truy cập bị từ chối" });
  }

  // Extract token from "Bearer xxx" format
  let token = authHeader;
  if (authHeader.startsWith("Bearer ")) {
    token = authHeader.slice(7);
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || "default_secret");  // Kiểm tra token hợp lệ
    req.user = decoded;  // Thêm thông tin người dùng vào request
    next();  // Tiến hành thực thi API sau khi xác thực
  } catch (err) {
    console.error('Token verification error:', err.message);
    res.status(401).json({ message: "Token không hợp lệ: " + err.message });
  }
};
