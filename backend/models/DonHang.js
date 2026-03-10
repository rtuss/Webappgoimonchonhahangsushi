// 📁 backend/models/DonHang.js
import mongoose from "mongoose";

const monTrongDonSchema = new mongoose.Schema({
  monAn: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "MonAn",
    required: true,
  },
  soLuong: { type: Number, required: true },
  ghiChuDacBiet: { type: String, default: "" },
});

const donHangSchema = new mongoose.Schema(
  {
    soBan: { type: Number, required: true },
    danhSachMon: [monTrongDonSchema],
    thoiGianDat: { type: Date, default: Date.now },
    tongTien: { type: Number, default: 0 }, // 💰 Tổng tiền đơn hàng

    // 🌟 TRẠNG THÁI – phải chứa đúng các trạng thái backend + Flutter đang dùng
    trangThai: {
      type: String,
      enum: [
        "cho_xac_nhan",        // khách vừa đặt xong
        "da_xac_nhan",         // nhân viên xác nhận
        "dang_che_bien",       // bếp đang làm
        "bep_hoan_tat",        // bếp hoàn tất → phục vụ nhận món
        "da_giao_mon",         // phục vụ giao cho khách
        "yeu_cau_thanh_toan",  // khách yêu cầu thanh toán
        "hoan_tat",            // đơn hoàn tất (đã thanh toán)
        "huy",                 // đơn bị hủy
      ],
      default: "cho_xac_nhan",
    },

    // 💳 PHƯƠNG THỨC THANH TOÁN
    phuongThucThanhToan: {
      type: String,
      enum: [
        "tien_mat",   // Thanh toán tiền mặt
        "chuyen_khoan",  // Chuyển khoản bình thường
        "viet_qr",    // Thanh toán VietQR
      ],
      default: null, // Chưa chọn phương thức thanh toán
    },
  },
  { timestamps: true }
);

export default mongoose.model("don_hang", donHangSchema);
