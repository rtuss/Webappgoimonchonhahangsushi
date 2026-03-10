// backend/scripts/seedStaff.js
import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import User from '../models/user.js';

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/sushi_app';

async function seedStaff() {
  try {
    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('✅ Connected to MongoDB');

    // Sample staff accounts
    const staffAccounts = [
      {
        tenDangNhap: 'staff1',
        email: 'staff1@sushi.com',
        matKhau: 'staff@123',
        hoTen: 'Nhân Viên 1',
        soDienThoai: '0901234567',
      },
      {
        tenDangNhap: 'staff2',
        email: 'staff2@sushi.com',
        matKhau: 'staff@123',
        hoTen: 'Nhân Viên 2',
        soDienThoai: '0902234567',
      },
      {
        tenDangNhap: 'staff3',
        email: 'staff3@sushi.com',
        matKhau: 'staff@123',
        hoTen: 'Nhân Viên 3',
        soDienThoai: '0903234567',
      },
    ];

    let createdCount = 0;

    for (const staffData of staffAccounts) {
      const existingStaff = await User.findOne({ tenDangNhap: staffData.tenDangNhap });
      if (existingStaff) {
        console.log(`⚠️  Staff ${staffData.tenDangNhap} already exists`);
        continue;
      }

      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(staffData.matKhau, salt);

      const newStaff = new User({
        tenDangNhap: staffData.tenDangNhap,
        email: staffData.email,
        matKhau: hashedPassword,
        vaiTro: 'staff',
        hoTen: staffData.hoTen,
        soDienThoai: staffData.soDienThoai,
        diaChi: 'Staff Address',
        daBiKhoa: false,
      });

      await newStaff.save();
      createdCount++;
      console.log(`✅ Created ${staffData.hoTen} (${staffData.email})`);
    }

    console.log(`\n📊 Created ${createdCount} staff accounts\n`);
    console.log('📋 Staff Credentials:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('All staff passwords: staff@123\n');

    staffAccounts.forEach((staff, index) => {
      console.log(`Staff ${index + 1}:`);
      console.log(`  Username: ${staff.tenDangNhap}`);
      console.log(`  Email: ${staff.email}`);
      console.log(`  Name: ${staff.hoTen}`);
      console.log(`  Phone: ${staff.soDienThoai}\n`);
    });

    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding staff:', error);
    process.exit(1);
  }
}

seedStaff();
