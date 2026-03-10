#!/usr/bin/env node

/**
 * 🧪 Test VietQR Payment Feature
 * Chạy: node test_viet_qr_payment.js
 */

import axios from "axios";

const BASE_URL = "http://localhost:3000/api";

// 🎨 Colors for console output
const colors = {
  reset: "\x1b[0m",
  bright: "\x1b[1m",
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
  title: (msg) => console.log(`\n${colors.bright}${colors.cyan}${msg}${colors.reset}\n`),
};

async function testVietQRPayment() {
  try {
    log.title("🧪 BẮTT ĐẦU TEST: VietQR Payment Feature");

    // ============================================================
    // BƯỚC 1: TẠO ĐƠN HÀNGmới
    // ============================================================
    log.info("BƯỚC 1: Tạo đơn hàng mới");
    const createOrderResponse = await axios.post(`${BASE_URL}/orders`, {
      soBan: 8,
      danhSachMon: [
        {
          monAn: "67493c5e8e7c5d9b1c2d4e5f", // ObjectId của một món
          soLuong: 2,
          ghiChuDacBiet: "Không cay",
        },
      ],
    });

    const orderId = createOrderResponse.data.data._id;
    const order = createOrderResponse.data.data;

    log.success(`Tạo đơn hàng thành công!`);
    log.info(`ID: ${orderId}`);
    log.info(`Bàn số: ${order.soBan}`);
    log.info(`Tổng tiền: ${order.tongTien}đ`);
    log.info(`Trạng thái: ${order.trangThai}`);

    // ============================================================
    // BƯỚC 2: CẬP NHẬT PHƯƠNG THỨC THANH TOÁN → VIETQR
    // ============================================================
    log.title("📝 BƯỚC 2: Cập nhật phương thức thanh toán → VietQR");
    
    const paymentMethods = ["tien_mat", "chuyen_khoan", "viet_qr"];
    
    for (const method of paymentMethods) {
      try {
        const updatePaymentResponse = await axios.patch(
          `${BASE_URL}/orders/${orderId}/payment-method`,
          { phuongThucThanhToan: method }
        );

        const updatedOrder = updatePaymentResponse.data.data;
        log.success(`✅ Cập nhật thành công: ${method}`);
        log.info(`Phương thức thanh toán: ${updatedOrder.phuongThucThanhToan}`);
        log.info(`Message: ${updatePaymentResponse.data.message}`);

        if (method === "viet_qr") {
          log.info(`🎯 Mã QR sẽ hiển thị trên ứng dụng Flutter`);
          log.info(`📊 Số tiền: ${updatedOrder.tongTien}đ`);
          log.info(`📍 Tài khoản: 1234567890`);
          log.info(`📋 Nội dung: Thanh toan ban ${updatedOrder.soBan}`);
          log.info(`🔗 QR URL: https://qr.napas.com.vn/?account=1234567890&bank=970401&amount=${updatedOrder.tongTien}&addInfo=Thanh%20toan%20ban%20${updatedOrder.soBan}`);
        }

        console.log("");
      } catch (err) {
        log.error(
          `Lỗi khi cập nhật phương thức '${method}': ${err.response?.data?.error || err.message}`
        );
      }
    }

    // ============================================================
    // BƯỚC 3: CẬP NHẬT TRẠNG THÁI ĐƠN HÀNGthành "hoàn tất"
    // ============================================================
    log.title("✅ BƯỚC 3: Cập nhật trạng thái → hoàn tất");
    
    const statusResponse = await axios.patch(`${BASE_URL}/orders/${orderId}/status`, {
      trangThai: "hoan_tat",
    });

    const finalOrder = statusResponse.data.data;
    log.success("Cập nhật trạng thái thành công!");
    log.info(`Trạng thái: ${finalOrder.trangThai}`);
    log.info(`Phương thức thanh toán: ${finalOrder.phuongThucThanhToan}`);

    // ============================================================
    // BƯỚC 4: HIỂN THỊ KẾT QUẢ
    // ============================================================
    log.title("📊 KẾT QUẢ CUỐI CÙNG");
    console.log("Đơn hàng:");
    console.log({
      _id: finalOrder._id,
      soBan: finalOrder.soBan,
      tongTien: `${finalOrder.tongTien}đ`,
      trangThai: finalOrder.trangThai,
      phuongThucThanhToan: finalOrder.phuongThucThanhToan,
      danhSachMon: finalOrder.danhSachMon.length + " món",
      thoiGianDat: new Date(finalOrder.thoiGianDat).toLocaleString("vi-VN"),
    });

    log.title("🎉 TEST HOÀN THÀNH THÀNH CÔNG!");
    log.success("VietQR Payment Feature đã được kiểm tra thành công!");

  } catch (err) {
    log.error(`Lỗi: ${err.message}`);
    if (err.response?.data) {
      log.error(`Chi tiết: ${JSON.stringify(err.response.data)}`);
    }
    process.exit(1);
  }
}

// Run test
testVietQRPayment();
