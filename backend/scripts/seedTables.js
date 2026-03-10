import mongoose from 'mongoose';
import dotenv from 'dotenv';
import Ban from '../models/Ban.js';

dotenv.config();

async function seedTables() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ MongoDB connected');

    // Clear existing tables
    await Ban.deleteMany({});
    console.log('🗑️  Cleared existing tables');

    // Create sample tables
    const tables = [];
    for (let i = 1; i <= 21; i++) {
      const table = new Ban({
        soBan: i,
        tenBan: `Bàn ${i}`,
        viTri: i <= 7 ? "Tầng 1" : i <= 14 ? "Tầng 2" : "Tầng 3",
        sucChua: 4,
        trangThai: 'trong',
        ghiChu: ''
      });

      await table.save();
      tables.push(table);
      console.log(`✅ Created table ${i}: Bàn ${table.tenBan}`);
    }

    const totalTables = await Ban.countDocuments();
    console.log(`\n📊 Total tables: ${totalTables}`);
    console.log('✨ Seed tables successful!');

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

seedTables();
