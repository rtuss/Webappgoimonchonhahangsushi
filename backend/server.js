// server.js
import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import { createServer } from "http";
import { Server } from "socket.io";

import authRoutes from "./routes/auth.js";
import menuRoutes from "./routes/menu.js";
import callStaffRoutes from "./routes/callStaff.js";
import tableRoutes from "./routes/tables.js";

import customerOrderRoutes from "./routes/customerOrders.js";  // khách hàng
import staffOrderRoutes from "./routes/staffOrders.js";        // nhân viên
import adminOrderRoutes from "./routes/adminOrderRoutes.js";   // admin

import chatRoutes from "./routes/chat.js";
import adminUserRoutes from "./routes/adminRoutes.js";
import { initChatSocket } from "./chat-socket.js";

dotenv.config();

const app = express();
app.use(express.json());

app.use(
  cors({
    origin: [
      "http://localhost:3000",
      "http://localhost:3001",
      "http://localhost:5000"
    ],
    credentials: true,
  })
);

// 🟢 Health check endpoint
app.get("/api/health", (req, res) => {
  res.json({ success: true, message: "Server is running" });
});

// DATABASE
mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error(err));

// ROUTES

// khách hàng — CHỈ route đặt món + xem đơn theo bàn
app.use("/api/orders", customerOrderRoutes);

// nhân viên — xem tất cả đơn + cập nhật
app.use("/api/staff/orders", staffOrderRoutes);

// admin — xem tất cả đơn + cập nhật
app.use("/api/admin/orders", adminOrderRoutes);

app.use("/api/auth", authRoutes);
app.use("/api/menu", menuRoutes);
app.use("/api/tables", tableRoutes);
app.use("/api/chat", chatRoutes);
app.use("/api/call-staff", callStaffRoutes);
app.use("/api/admin", adminUserRoutes);

const server = createServer(app);
const io = new Server(server, { cors: { origin: "*" } });
initChatSocket(io);

server.listen(3000, () =>
  console.log("Server running at http://localhost:3000")
);
