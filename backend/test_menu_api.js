import mongoose from 'mongoose';
import dotenv from 'dotenv';
import MonAn from './models/MonAn.js';

dotenv.config();

async function testMenuAPI() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ MongoDB connected');

    // Count menu items
    const count = await MonAn.countDocuments();
    console.log(`📊 Total menu items in DB: ${count}`);

    // Get all menus
    const menus = await MonAn.find().limit(3);
    console.log('\n📝 Sample menus:');
    menus.forEach(m => {
      console.log(`  - ${m.tenMon} (${m.loaiMon}): ${m.gia}k`);
    });

    if (count === 0) {
      console.log('\n⚠️ NO DATA! Need to seed menu first');
      console.log('Run: npm run seed:menu');
    } else {
      console.log('\n✅ API should work! Menu data exists');
    }

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

testMenuAPI();
