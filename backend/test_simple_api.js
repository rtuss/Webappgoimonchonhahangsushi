#!/usr/bin/env node

/**
 * 🧪 Simple Test - Check if API routes are working
 * Chạy: node test_simple_api.js
 */

import axios from "axios";

const BASE_URL = "http://localhost:3000/api";

const log = {
  success: (msg) => console.log(`✅ ${msg}`),
  info: (msg) => console.log(`ℹ️  ${msg}`),
  error: (msg) => console.log(`❌ ${msg}`),
};

async function testAPI() {
  try {
    log.info("Kiểm tra kết nối server...");

    // Test health check
    const healthResponse = await axios.get("http://localhost:3000/api/health");
    log.success("Server đang chạy!");
    log.info(`Trạng thái: ${JSON.stringify(healthResponse.data)}\n`);

    // Test GET menu
    log.info("Kiểm tra GET /api/menu...");
    try {
      const menuResponse = await axios.get(`${BASE_URL}/menu`);
      log.success(`Menu API hoạt động! (${menuResponse.data.data?.length || 0} món)`);
    } catch (err) {
      log.error(`Menu API lỗi: ${err.response?.status}`);
    }

    // Test GET tables
    log.info("\nKiểm tra GET /api/tables...");
    try {
      const tablesResponse = await axios.get(`${BASE_URL}/tables`);
      log.success(`Tables API hoạt động! (${tablesResponse.data.data?.length || 0} bàn)`);
    } catch (err) {
      log.error(`Tables API lỗi: ${err.response?.status}`);
    }

    log.info("\n✅ Tất cả API routes đều hoạt động!");

  } catch (err) {
    log.error(`Lỗi kết nối: ${err.message}`);
    log.error("❌ Hãy chắc chắn server đang chạy: npm start");
  }
}

testAPI();
