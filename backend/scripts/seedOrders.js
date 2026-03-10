import mongoose from 'mongoose';
import dotenv from 'dotenv';
import DonHang from '../models/DonHang.js';
import MonAn from '../models/MonAn.js';

dotenv.config();

async function seedOrders() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ MongoDB connected');

    // Get some menu items
    const menus = await MonAn.find().limit(10);
    if (menus.length === 0) {
      console.error('❌ No menu items found. Run seed:menu first');
      process.exit(1);
    }

    // Clear existing orders
    await DonHang.deleteMany({});
    console.log('🗑️  Cleared existing orders');

    // Create sample orders
    const orders = [];
    const statuses = [
      'cho_xac_nhan',
      'da_xac_nhan',
      'dang_che_bien',
      'bep_hoan_tat',
      'da_giao_mon',
      'yeu_cau_thanh_toan',
      'hoan_tat',
      'huy'
    ];

    for (let i = 1; i <= 12; i++) {
      const itemCount = Math.floor(Math.random() * 3) + 1;
      const danhSachMon = [];
      let tongTien = 0;

      for (let j = 0; j < itemCount; j++) {
        const menu = menus[Math.floor(Math.random() * menus.length)];
        const soLuong = Math.floor(Math.random() * 3) + 1;
        danhSachMon.push({
          monAn: menu._id,
          soLuong: soLuong,
          ghiChuDacBiet: j === 0 ? 'Không tiêu' : ''
        });
        tongTien += (menu.gia || 0) * soLuong;
      }

      const order = new DonHang({
        soBan: Math.floor(Math.random() * 8) + 1,
        danhSachMon: danhSachMon,
        tongTien: tongTien,
        trangThai: statuses[Math.floor(Math.random() * statuses.length)],
        thoiGianDat: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000) // Random within 7 days
      });

      await order.save();
      orders.push(order);
      console.log(`✅ Created order ${i}: Bàn ${order.soBan}, ${tongTien.toLocaleString('vi-VN')}đ`);
    }

    const totalRevenue = orders.reduce((sum, order) => sum + order.tongTien, 0);
    console.log(`\n📊 Total orders: ${orders.length}`);
    console.log(`💰 Total revenue: ${totalRevenue.toLocaleString('vi-VN')}đ`);
    console.log('✨ Seed orders successful!');

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

seedOrders();
