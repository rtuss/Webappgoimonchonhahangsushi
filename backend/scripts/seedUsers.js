import mongoose from 'mongoose';
import dotenv from 'dotenv';
import User from '../models/user.js';
import bcrypt from 'bcryptjs';

dotenv.config();

const usersData = [
  {
    email: 'admin@sushi.com',
    fullName: 'Nguyễn Văn Admin',
    role: 'admin',
    phone: '0905123456',
    password: 'admin@123'
  },
  {
    email: 'staff1@sushi.com',
    fullName: 'Trần Thị Staff 1',
    role: 'staff',
    phone: '0905234567',
    password: 'staff@123'
  },
  {
    email: 'staff2@sushi.com',
    fullName: 'Hoàng Văn Staff 2',
    role: 'staff',
    phone: '0905345678',
    password: 'staff@123'
  },
  {
    email: 'staff3@sushi.com',
    fullName: 'Lê Thị Staff 3',
    role: 'staff',
    phone: '0905456789',
    password: 'staff@123'
  },
  {
    email: 'staff4@sushi.com',
    fullName: 'Phạm Văn Staff 4',
    role: 'staff',
    phone: '0905567890',
    password: 'staff@123'
  },
];

async function seedUsers() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ MongoDB connected');

    // Add new users
    for (const userData of usersData) {
      const existingUser = await User.findOne({ email: userData.email });
      
      if (!existingUser) {
        const hashedPassword = await bcrypt.hash(userData.password, 10);
        
        const newUser = new User({
          email: userData.email,
          fullName: userData.fullName,
          role: userData.role,
          phone: userData.phone,
          matKhau: hashedPassword,
          tenDangNhap: userData.email.split('@')[0],
          vaiTro: userData.role,
          hoTen: userData.fullName,
        });

        await newUser.save();
        console.log(`✅ Created: ${userData.email} (${userData.role})`);
      } else {
        // Update existing user with new fields
        const updatedUser = await User.findOneAndUpdate(
          { email: userData.email },
          {
            fullName: userData.fullName,
            role: userData.role,
            phone: userData.phone,
            hoTen: userData.fullName,
            vaiTro: userData.role
          },
          { new: true }
        );
        console.log(`✏️  Updated: ${userData.email}`);
      }
    }

    const totalUsers = await User.countDocuments();
    console.log(`\n📊 Total users in DB: ${totalUsers}`);

    console.log('\n✨ Seed users successful!');

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

seedUsers();
