import mongoose from 'mongoose';
import dotenv from 'dotenv';
import MonAn from '../models/MonAn.js';
import DonHang from '../models/DonHang.js';

dotenv.config();

async function updatePrices() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ MongoDB connected');

    // Update menu prices
    const menus = await MonAn.find();
    for (const menu of menus) {
      if (menu.gia < 1000) {
        menu.gia = menu.gia * 1000;
        await menu.save();
        console.log(`✅ Updated ${menu.tenMon}: ${menu.gia}đ`);
      }
    }

    // Update order totals
    const orders = await DonHang.find();
    for (const order of orders) {
      if (order.tongTien < 100000) {
        order.tongTien = order.tongTien * 1000;
        await order.save();
        console.log(`✅ Updated order Bàn ${order.soBan}: ${order.tongTien}đ`);
      }
    }

    console.log('\n✨ Price update successful!');
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

updatePrices();
