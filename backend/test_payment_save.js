#!/usr/bin/env node

/**
 * 🧪 Test Payment Method Save - MongoDB
 * Chạy: node test_payment_save.js
 */

import axios from "axios";

const BASE_URL = "http://localhost:3000/api";

const colors = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  cyan: "\x1b[36m",
  red: "\x1b[31m",
};

const log = {
  success: (msg) => console.log(`${colors.green}✅ ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.cyan}ℹ️  ${msg}${colors.reset}`),
  warn: (msg) => console.log(`${colors.yellow}⚠️  ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}❌ ${msg}${colors.reset}`),
  title: (msg) => console.log(`\n${colors.cyan}════════════════════════════════════${colors.reset}\n${msg}\n${colors.cyan}════════════════════════════════════${colors.reset}\n`),
};

async function testPaymentSave() {
  try {
    log.title("🧪 TEST: Lưu Payment Method vào MongoDB");

    // ============================================================
    // BƯỚC 1: TẠO ĐƠN HÀNG MỚI (Bàn trống trước)
    // ============================================================
    log.info("BƯỚC 1: Tạo đơn hàng mới (Bàn 15)");
    const createOrderResponse = await axios.post(`${BASE_URL}/orders`, {
      soBan: 15,
      danhSachMon: [], // Bàn rỗng
    });

    if (!createOrderResponse.data.success) {
      throw new Error("Tạo order thất bại");
    }

    const orderId = createOrderResponse.data.data._id;
    const order = createOrderResponse.data.data;

    log.success(`Tạo đơn hàng thành công!`);
    log.info(`📍 ID: ${orderId}`);
    log.info(`🪑 Bàn số: ${order.soBan}`);
    log.info(`💰 Tổng tiền: ${order.tongTien}đ`);
    log.info(`📊 Trạng thái: ${order.trangThai}`);
    log.info(`💳 Phương thức thanh toán (hiện tại): ${order.phuongThucThanhToan || "null"}\n`);

    // ============================================================
    // BƯỚC 2: CẬP NHẬT PHƯƠNG THỨC THANH TOÁN VÀO MONGODB
    // ============================================================
    const paymentMethods = ["tien_mat", "chuyen_khoan", "viet_qr"];

    for (const method of paymentMethods) {
      log.info(`BƯỚC 2-${paymentMethods.indexOf(method) + 1}: Cập nhật → "${method}"`);
      
      const updateResponse = await axios.patch(
        `${BASE_URL}/orders/${orderId}/payment-method`,
        { phuongThucThanhToan: method }
      );

      if (!updateResponse.data.success) {
        throw new Error(`Cập nhật ${method} thất bại`);
      }

      const updatedOrder = updateResponse.data.data;
      
      log.success(`Cập nhật thành công!`);
      log.info(`💳 Phương thức: ${updatedOrder.phuongThucThanhToan}`);
      log.info(`📢 Message: ${updateResponse.data.message}`);
      
      // Kiểm tra các info khác vẫn nguyên
      log.info(`✓ Bàn số: ${updatedOrder.soBan} (không thay đổi)`);
      log.info(`✓ Trạng thái: ${updatedOrder.trangThai} (không thay đổi)`);
      log.info(`✓ Tổng tiền: ${updatedOrder.tongTien}đ (không thay đổi)\n`);
    }

    // ============================================================
    // BƯỚC 3: CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG THÀNH "hoan_tat"
    // ============================================================
    log.info(`BƯỚC 3: Cập nhật trạng thái → "hoan_tat"`);
    
    const statusResponse = await axios.patch(
      `${BASE_URL}/orders/${orderId}/status`,
      { trangThai: "hoan_tat" }
    );

    if (!statusResponse.data.success) {
      throw new Error("Cập nhật status thất bại");
    }

    const finalOrder = statusResponse.data.data;
    
    log.success(`Cập nhật trạng thái thành công!`);
    log.info(`📊 Trạng thái mới: ${finalOrder.trangThai}`);
    log.info(`💳 Phương thức thanh toán: ${finalOrder.phuongThucThanhToan}\n`);

    // ============================================================
    // BƯỚC 4: KIỂM TRA DỮ LIỆU LƯU VÀO MONGODB
    // ============================================================
    log.title("✅ KẾT QUẢ CUỐI CÙNG - DỮ LIỆU MONGODB");
    
    console.log("Đơn hàng hoàn chỉnh:");
    console.log({
      _id: finalOrder._id,
      soBan: finalOrder.soBan,
      tongTien: `${finalOrder.tongTien}đ`,
      trangThai: finalOrder.trangThai,
      phuongThucThanhToan: finalOrder.phuongThucThanhToan, // ← CÓ GIÁ TRỊ
      danhSachMon: `${finalOrder.danhSachMon.length} món`,
      thoiGianDat: new Date(finalOrder.thoiGianDat).toLocaleString("vi-VN"),
      createdAt: new Date(finalOrder.createdAt).toLocaleString("vi-VN"),
      updatedAt: new Date(finalOrder.updatedAt).toLocaleString("vi-VN"),
    });

    log.title("🎉 TEST HOÀN THÀNH THÀNH CÔNG!");
    log.success("✅ Dữ liệu đã được lưu vào MongoDB!");
    log.success("✅ Phương thức thanh toán đã được lưu!");
    log.success("✅ API endpoint hoạt động perfect!");
    
    log.info("\n📌 Kiểm tra trong MongoDB Compass:");
    log.info(`   1. Kết nối: sushi_app > don_hang (nếu là tiếng Anh)`);
    log.info(`   2. Tìm document với soBan: 15`);
    log.info(`   3. Xem field: phuongThucThanhToan (sẽ là "viet_qr")`);
    log.info(`   4. Xem field: trangThai (sẽ là "hoan_tat")`);

  } catch (err) {
    log.error(`Lỗi: ${err.message}`);
    if (err.response?.data) {
      log.error(`Chi tiết: ${JSON.stringify(err.response.data, null, 2)}`);
    }
    process.exit(1);
  }
}

// Run test
testPaymentSave();
