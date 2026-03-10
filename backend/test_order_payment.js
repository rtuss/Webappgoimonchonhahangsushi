// 🧪 Test Script: Tạo Order + Test Thanh Toán
// Chạy: node test_order_payment.js

import axios from 'axios';

const BASE_URL = 'http://localhost:3000';

// 🟢 ID của các món ăn (cần có sẵn trong DB)
// Hãy chạy script này để tìm ID:
// db.mon_an.find({}, {tenMon: 1, gia: 1})

const testMonAnIds = [
  // Bạn cần thay bằng ID thực tế từ DB
  // Ví dụ: '60c72b2f4f1a1c2e3a4b5c6d'
];

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function testOrderPayment() {
  try {
    console.log('\n======================================');
    console.log('🧪 BẮT ĐẦU TEST: TẠO ORDER + THANH TOÁN');
    console.log('======================================\n');

    // BƯỚC 1: Lấy danh sách mon ăn từ backend
    console.log('📝 BƯỚC 1: Lấy danh sách món ăn...');
    const menusRes = await axios.get(`${BASE_URL}/api/menu`);
    const menus = menusRes.data.data || [];
    
    if (menus.length === 0) {
      console.error('❌ Không có món ăn trong DB');
      return;
    }

    // Chọn 2 món đầu tiên
    const mon1 = menus[0];
    const mon2 = menus[1];

    console.log(`✅ Tìm được ${menus.length} món`);
    console.log(`  - Món 1: ${mon1.tenMon} (${mon1.gia}k)`);
    console.log(`  - Món 2: ${mon2.tenMon} (${mon2.gia}k)`);

    // BƯỚC 2: Tạo order
    console.log('\n📝 BƯỚC 2: TẠO ORDER MỚI...');
    
    const orderData = {
      soBan: 5,
      danhSachMon: [
        {
          monAn: mon1._id,
          soLuong: 2,
          ghiChuDacBiet: 'Không cay'
        },
        {
          monAn: mon2._id,
          soLuong: 1,
          ghiChuDacBiet: ''
        }
      ]
    };

    console.log('📤 Gửi request tạo order:', JSON.stringify(orderData, null, 2));

    const createRes = await axios.post(`${BASE_URL}/api/orders`, orderData);
    const order = createRes.data.data;

    if (!order || !order._id) {
      console.error('❌ Lỗi: Không nhận được ID order');
      return;
    }

    console.log(`✅ TẠO ORDER THÀNH CÔNG!`);
    console.log(`  - Order ID: ${order._id}`);
    console.log(`  - Bàn: ${order.soBan}`);
    console.log(`  - Trạng thái: ${order.trangThai}`);
    console.log(`  - Tổng tiền: ${order.tongTien}đ`);
    console.log(`  - Danh sách món: ${order.danhSachMon.length} món`);

    const orderId = order._id;

    // BƯỚC 3: Lấy order để xác nhận
    console.log('\n📝 BƯỚC 3: LẤY THÔNG TIN ORDER...');
    const getRes = await axios.get(`${BASE_URL}/api/orders/table/5`);
    const orders = getRes.data.data;
    console.log(`✅ Lấy được ${orders.length} order từ bàn 5`);

    // BƯỚC 4: Update trạng thái → "da_xac_nhan" (nhân viên xác nhận)
    console.log('\n📝 BƯỚC 4: CẬP NHẬT TRẠNG THÁI → "da_xac_nhan" (Xác nhận)');
    let updateRes = await axios.patch(
      `${BASE_URL}/api/staff/orders/${orderId}/status`,
      { trangThai: 'da_xac_nhan' }
    );
    console.log(`✅ Trạng thái: ${updateRes.data.data.trangThai}`);
    await sleep(1000);

    // BƯỚC 5: Update → "dang_che_bien" (Bếp đang làm)
    console.log('\n📝 BƯỚC 5: CẬP NHẬT TRẠNG THÁI → "dang_che_bien" (Bếp đang làm)');
    updateRes = await axios.patch(
      `${BASE_URL}/api/staff/orders/${orderId}/status`,
      { trangThai: 'dang_che_bien' }
    );
    console.log(`✅ Trạng thái: ${updateRes.data.data.trangThai}`);
    await sleep(1000);

    // BƯỚC 6: Update → "bep_hoan_tat" (Bếp hoàn tất)
    console.log('\n📝 BƯỚC 6: CẬP NHẬT TRẠNG THÁI → "bep_hoan_tat" (Bếp hoàn tất)');
    updateRes = await axios.patch(
      `${BASE_URL}/api/staff/orders/${orderId}/status`,
      { trangThai: 'bep_hoan_tat' }
    );
    console.log(`✅ Trạng thái: ${updateRes.data.data.trangThai}`);
    await sleep(1000);

    // BƯỚC 7: Update → "da_giao_mon" (Đã giao cho khách)
    console.log('\n📝 BƯỚC 7: CẬP NHẬT TRẠNG THÁI → "da_giao_mon" (Đã giao cho khách)');
    updateRes = await axios.patch(
      `${BASE_URL}/api/staff/orders/${orderId}/status`,
      { trangThai: 'da_giao_mon' }
    );
    console.log(`✅ Trạng thái: ${updateRes.data.data.trangThai}`);
    console.log(`   🟢 TẠI ĐÂY KHÁCH CÓ THỂ BẤM "YÊU CẦU THANH TOÁN"`);
    await sleep(1000);

    // BƯỚC 8: Update → "yeu_cau_thanh_toan" (Yêu cầu thanh toán - Khách bấm nút)
    console.log('\n📝 BƯỚC 8: CẬP NHẬT TRẠNG THÁI → "yeu_cau_thanh_toan" (Khách yêu cầu thanh toán)');
    updateRes = await axios.patch(
      `${BASE_URL}/api/staff/orders/${orderId}/status`,
      { trangThai: 'yeu_cau_thanh_toan' }
    );
    console.log(`✅ Trạng thái: ${updateRes.data.data.trangThai}`);
    console.log(`   🟡 NHÂN VIÊN NHẬN THANH TOÁN RỒI...`);
    await sleep(1000);

    // BƯỚC 9: Update → "hoan_tat" (Hoàn tất - Thanh toán xong)
    console.log('\n📝 BƯỚC 9: CẬP NHẬT TRẠNG THÁI → "hoan_tat" (Thanh toán xong - Khách bấm nút "Hoàn tất")');
    updateRes = await axios.patch(
      `${BASE_URL}/api/staff/orders/${orderId}/status`,
      { trangThai: 'hoan_tat' }
    );
    console.log(`✅ Trạng thái: ${updateRes.data.data.trangThai}`);
    console.log(`   ✅ HOÀN TẤT ĐƠN HÀNG`);

    console.log('\n======================================');
    console.log('✅ TEST HOÀN THÀNH THÀNH CÔNG!');
    console.log('======================================\n');

    // Tóm tắt
    console.log('📊 TÓM TẮT QUYTRÌNH THANH TOÁN:');
    console.log('1. ✅ Tạo order: cho_xac_nhan');
    console.log('2. ✅ Nhân viên xác nhận: da_xac_nhan');
    console.log('3. ✅ Bếp đang làm: dang_che_bien');
    console.log('4. ✅ Bếp hoàn tất: bep_hoan_tat');
    console.log('5. ✅ Giao cho khách: da_giao_mon');
    console.log('6. 🔴 KHÁCH BẤM "YÊU CẦU THANH TOÁN": yeu_cau_thanh_toan');
    console.log('7. 🟡 NHÂN VIÊN THANH TOÁN...');
    console.log('8. 🟢 KHÁCH BẤM "HOÀN TẤT": hoan_tat');
    console.log('\n');

  } catch (error) {
    console.error('❌ LỖI:', error.response?.data || error.message);
  }
}

// Chạy test
testOrderPayment();
