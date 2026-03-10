// 📄 lib/models/donhang_model.dart
import 'menu_model.dart';

/// 🔹 Mô hình dữ liệu cho một đơn hàng trong MongoDB
class DonHangModel {
  final String? id; // 🆔 Mã đơn hàng (MongoDB _id)
  final int soBan; // 🪑 Số bàn (xác định qua mã QR)
  final List<MonTrongDonModel> danhSachMon; // 🍣 Danh sách món khách đã chọn
  final DateTime thoiGianDat; // ⏰ Thời gian đặt hàng

  /// 🟢 TRẠNG THÁI ĐƠN HÀNG (KHỚP BACKEND)
  /// - cho_xac_nhan: khách vừa đặt
  /// - da_xac_nhan: nhân viên xác nhận
  /// - dang_che_bien: bếp đang làm
  /// - bep_hoan_tat: bếp hoàn tất
  /// - da_giao_mon: đã giao cho khách
  /// - yeu_cau_thanh_toan: khách yêu cầu thanh toán
  /// - hoan_tat: đơn hoàn tất (đã thanh toán)
  /// - huy: đơn bị hủy
  final String trangThai;

  DonHangModel({
    this.id,
    required this.soBan,
    required this.danhSachMon,
    this.trangThai = "da_dat",
    DateTime? thoiGianDat,
  }) : thoiGianDat = thoiGianDat ?? DateTime.now();

  /// 🔹 Tính tổng tiền
  double get tongTien =>
      danhSachMon.fold(0, (tong, mon) => tong + mon.tongTien);

  /// *********************************************************************
  /// ⭐⭐ HÀM copyWith() — QUAN TRỌNG ⭐⭐
  /// *********************************************************************
  DonHangModel copyWith({
    String? id,
    int? soBan,
    List<MonTrongDonModel>? danhSachMon,
    String? trangThai,
    DateTime? thoiGianDat,
  }) {
    return DonHangModel(
      id: id ?? this.id,
      soBan: soBan ?? this.soBan,
      danhSachMon: danhSachMon ?? this.danhSachMon,
      trangThai: trangThai ?? this.trangThai,
      thoiGianDat: thoiGianDat ?? this.thoiGianDat,
    );
  }

  /// 🔹 JSON → Model
  factory DonHangModel.fromJson(Map<String, dynamic> json) {
    return DonHangModel(
      id: json['_id'] ?? json['id'],
      soBan: int.tryParse(json['soBan'].toString()) ?? 0,
      danhSachMon: (json['danhSachMon'] as List<dynamic>? ?? [])
          .map((item) => MonTrongDonModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      trangThai: json['trangThai'] ?? "cho_xac_nhan",
      thoiGianDat: json['thoiGianDat'] != null
          ? DateTime.parse(json['thoiGianDat'].toString())
          : DateTime.now(),
    );
  }

  /// 🔹 Model → JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'soBan': soBan,
      'thoiGianDat': thoiGianDat.toIso8601String(),
      'trangThai': trangThai,
      'danhSachMon': danhSachMon.map((m) => m.toJson()).toList(),
      'tongTien': tongTien,
    };
  }
}

/// 🔸 Model món trong đơn hàng
class MonTrongDonModel {
  final MonAnModel monAn; // 🍱 Món ăn
  final int soLuong; // 🔢 Số lượng
  final String? ghiChuDacBiet; // 📝 Ghi chú thêm

  MonTrongDonModel({
    required this.monAn,
    required this.soLuong,
    this.ghiChuDacBiet,
  });

  double get tongTien => monAn.giaSauGiam * soLuong; // Giá đã là VND, không nhân 1000

  /// ⭐ copyWith() cho từng món trong đơn hàng
  MonTrongDonModel copyWith({
    MonAnModel? monAn,
    int? soLuong,
    String? ghiChuDacBiet,
  }) {
    return MonTrongDonModel(
      monAn: monAn ?? this.monAn,
      soLuong: soLuong ?? this.soLuong,
      ghiChuDacBiet: ghiChuDacBiet ?? this.ghiChuDacBiet,
    );
  }

  factory MonTrongDonModel.fromJson(Map<String, dynamic> json) {
    // Xử lý khi monAn là string (ObjectId), object, hoặc null
    MonAnModel monAn;
    
    if (json['monAn'] == null) {
      // Nếu monAn null, tạo placeholder
      monAn = MonAnModel(
        id: 'unknown',
        tenMon: '(Không có dữ liệu)',
        moTa: '',
        gia: 0,
        loaiMon: '',
        hinhAnh: '',
      );
    } else if (json['monAn'] is String) {
      // Nếu là string (ObjectId), tạo một MonAnModel tạm thời
      monAn = MonAnModel(
        id: json['monAn'] as String,
        tenMon: '',
        moTa: '',
        gia: 0,
        loaiMon: '',
        hinhAnh: '',
      );
    } else if (json['monAn'] is Map) {
      monAn = MonAnModel.fromJson(json['monAn'] as Map<String, dynamic>);
    } else {
      print('⚠️ Invalid monAn format: ${json['monAn'].runtimeType}');
      // Fallback: tạo placeholder
      monAn = MonAnModel(
        id: 'unknown',
        tenMon: '(Lỗi dữ liệu)',
        moTa: '',
        gia: 0,
        loaiMon: '',
        hinhAnh: '',
      );
    }

    return MonTrongDonModel(
      monAn: monAn,
      soLuong: json['soLuong'] ?? 1,
      ghiChuDacBiet: json['ghiChuDacBiet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monAn': monAn.toJson(),
      'soLuong': soLuong,
      'ghiChuDacBiet': ghiChuDacBiet,
    };
  }
}
