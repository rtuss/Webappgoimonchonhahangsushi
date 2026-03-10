import mongoose from 'mongoose';
import dotenv from 'dotenv';
import MonAn from '../models/MonAn.js';

dotenv.config();

const menuData = [
  // Sushi
  {
    tenMon: "California Roll",
    moTa: "Cơm, crab stick, dưa, góc tôm",
    gia: 45,
    loaiMon: "Sushi",
    hinhAnh: "https://via.placeholder.com/300x200?text=California+Roll",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Philadelphia Roll",
    moTa: "Cơm, cá hồi, phô mai cream, dưa chuối",
    gia: 55,
    loaiMon: "Sushi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Philadelphia+Roll",
    giamGia: 5,
    conPhucVu: true,
  },
  {
    tenMon: "Dragon Roll",
    moTa: "Cơm, tôm, cá bơi, trứng cá",
    gia: 60,
    loaiMon: "Sushi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Dragon+Roll",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Rainbow Roll",
    moTa: "California roll với nhiều loại cá tươi",
    gia: 65,
    loaiMon: "Sushi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Rainbow+Roll",
    giamGia: 10,
    conPhucVu: true,
  },
  {
    tenMon: "Spicy Tuna Roll",
    moTa: "Cơm, cá ngừ cay, mayonnaise, dưa",
    gia: 50,
    loaiMon: "Sushi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Spicy+Tuna",
    giamGia: 0,
    conPhucVu: true,
  },

  // Sashimi
  {
    tenMon: "Salmon Sashimi",
    moTa: "5 lát cá hồi tươi",
    gia: 85,
    loaiMon: "Sashimi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Salmon+Sashimi",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Tuna Sashimi",
    moTa: "5 lát cá ngừ tươi",
    gia: 90,
    loaiMon: "Sashimi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Tuna+Sashimi",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Mixed Sashimi",
    moTa: "Hỗn hợp cá hồi, cá ngừ, sò, mực",
    gia: 120,
    loaiMon: "Sashimi",
    hinhAnh: "https://via.placeholder.com/300x200?text=Mixed+Sashimi",
    giamGia: 5,
    conPhucVu: true,
  },

  // Set combo
  {
    tenMon: "Combo Starter",
    moTa: "6 miếng sushi + 3 miếng sashimi + canh miso",
    gia: 150,
    loaiMon: "Set combo",
    hinhAnh: "https://via.placeholder.com/300x200?text=Combo+Starter",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Combo Premium",
    moTa: "8 miếng sushi + 5 miếng sashimi + salad + canh miso + dessert",
    gia: 250,
    loaiMon: "Set combo",
    hinhAnh: "https://via.placeholder.com/300x200?text=Combo+Premium",
    giamGia: 15,
    conPhucVu: true,
  },
  {
    tenMon: "Combo Family",
    moTa: "2 cuộn sushi + 3 miếng sashimi + tempura + salad (4 người)",
    gia: 450,
    loaiMon: "Set combo",
    hinhAnh: "https://via.placeholder.com/300x200?text=Combo+Family",
    giamGia: 20,
    conPhucVu: true,
  },

  // Tempura
  {
    tenMon: "Shrimp Tempura",
    moTa: "Tôm chiên xù, sốt cay, dressing sesame",
    gia: 65,
    loaiMon: "Tempura",
    hinhAnh: "https://via.placeholder.com/300x200?text=Shrimp+Tempura",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Vegetable Tempura",
    moTa: "Rau quả chiên xù, sốt miso",
    gia: 45,
    loaiMon: "Tempura",
    hinhAnh: "https://via.placeholder.com/300x200?text=Vegetable+Tempura",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Mixed Tempura",
    moTa: "Tôm, cá, rau, nấm chiên xù",
    gia: 75,
    loaiMon: "Tempura",
    hinhAnh: "https://via.placeholder.com/300x200?text=Mixed+Tempura",
    giamGia: 0,
    conPhucVu: true,
  },

  // Salad
  {
    tenMon: "Seaweed Salad",
    moTa: "Rong biển tươi, mầm, sốt sesame",
    gia: 35,
    loaiMon: "Salad",
    hinhAnh: "https://via.placeholder.com/300x200?text=Seaweed+Salad",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Salmon Salad",
    moTa: "Cá hồi, rau tươi, dressing lemon",
    gia: 55,
    loaiMon: "Salad",
    hinhAnh: "https://via.placeholder.com/300x200?text=Salmon+Salad",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Tuna Tataki Salad",
    moTa: "Cá ngừ nướng nhẹ, rau tươi, sốt ponzu",
    gia: 75,
    loaiMon: "Salad",
    hinhAnh: "https://via.placeholder.com/300x200?text=Tuna+Tataki",
    giamGia: 10,
    conPhucVu: true,
  },

  // Đồ uống
  {
    tenMon: "Trà Xanh Lạnh",
    moTa: "Trà xanh tươi mát, không đường",
    gia: 15,
    loaiMon: "Đồ uống",
    hinhAnh: "https://via.placeholder.com/300x200?text=Tra+Xanh",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Nước Chanh Tươi",
    moTa: "Chanh tây ép tươi, đá mịn",
    gia: 18,
    loaiMon: "Đồ uống",
    hinhAnh: "https://via.placeholder.com/300x200?text=Nuoc+Chanh",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Nước Cam Tươi",
    moTa: "Cam Việt ép tươi 100%",
    gia: 20,
    loaiMon: "Đồ uống",
    hinhAnh: "https://via.placeholder.com/300x200?text=Nuoc+Cam",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Sake Nóng",
    moTa: "Rượu Sake Nhật truyền thống, phục vụ nóng",
    gia: 50,
    loaiMon: "Đồ uống",
    hinhAnh: "https://via.placeholder.com/300x200?text=Sake",
    giamGia: 0,
    conPhucVu: true,
  },
  {
    tenMon: "Beer Lạnh",
    moTa: "Bia nhập khẩu, lạnh -5°C",
    gia: 35,
    loaiMon: "Đồ uống",
    hinhAnh: "https://via.placeholder.com/300x200?text=Beer",
    giamGia: 0,
    conPhucVu: true,
  },
];

async function seedMenu() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/sushi_admin');
    console.log('✅ MongoDB đã kết nối');

    // Clear existing menu
    await MonAn.deleteMany({});
    console.log('🗑️  Đã xóa menu cũ');

    // Insert new menu
    const result = await MonAn.insertMany(menuData);
    console.log(`✅ Đã thêm ${result.length} món ăn vào database`);

    // Display summary
    const summary = {};
    result.forEach(item => {
      summary[item.loaiMon] = (summary[item.loaiMon] || 0) + 1;
    });
    
    console.log('\n📊 Tổng hợp menu:');
    Object.entries(summary).forEach(([type, count]) => {
      console.log(`   ${type}: ${count} món`);
    });

    console.log('\n✨ Seed menu thành công!');
  } catch (error) {
    console.error('❌ Lỗi seed menu:', error.message);
  } finally {
    await mongoose.connection.close();
  }
}

seedMenu();
