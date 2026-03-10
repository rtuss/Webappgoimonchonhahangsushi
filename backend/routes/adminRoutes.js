import express from "express";
import { auth } from "../Middleware/authMiddleware.js";  // Import middleware auth
import { registerUser, getUsers, updateUser, updateUserRole, deleteUser } from "../controllers/userController.js";  // Sử dụng named import
import { getTables, createTable, updateTable, deleteTable } from "../controllers/tableController.js";

const router = express.Router();

// Route cho đăng ký người dùng mới (không cần auth)
router.post("/register", registerUser);  // Đăng ký người dùng mới

// Các route cho người dùng
router.get("/users", auth, getUsers);  // Bảo vệ route với auth
router.post("/users", auth, registerUser);  // Tạo user mới (bảo vệ với auth)
router.patch("/users/:id", auth, updateUser);  // Cập nhật thông tin người dùng (bảo vệ với auth)
router.put("/users/:id", auth, updateUserRole);  // Cập nhật vai trò người dùng
router.delete("/users/:id", auth, deleteUser);  // Xóa người dùng

// Các route cho bàn ăn
router.get("/tables", auth, getTables);  // Lấy danh sách bàn
router.post("/tables", auth, createTable);  // Tạo bàn mới
router.patch("/tables/:id", auth, updateTable);  // Cập nhật bàn
router.delete("/tables/:id", auth, deleteTable);  // Xóa bàn

export default router;
