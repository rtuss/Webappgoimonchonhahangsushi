// lib/models/ban_an_model.dart

class BanAnModel {
  final String maBan; // Mã bàn
  final String soBan; // Số bàn
  final String trangThai; // Trạng thái bàn (Trống, Đã có khách, Bảo trì)
  final String? maQR; // Mã QR của bàn
  final String viTri; // Vị trí bàn (Tầng 1, Tầng 2)
  final String? ghiChu; // Ghi chú cho bàn
  final DateTime ngayTao; // Ngày tạo thông tin bàn

  BanAnModel({
    required this.maBan,
    required this.soBan,
    required this.trangThai,
    this.maQR,
    required this.viTri,
    this.ghiChu,
    required this.ngayTao,
  });

  factory BanAnModel.fromJson(Map<String, dynamic> json) {
    return BanAnModel(
      maBan: json['maBan'] ?? json['_id'] ?? json['id'] ?? '',
      soBan: json['soBan'] ?? json['so_ban'] ?? '',
      trangThai: json['trangThai'] ?? json['trang_thai'] ?? 'Trống',
      maQR: json['maQR'] ?? json['ma_qr'],
      viTri: json['viTri'] ?? json['vi_tri'] ?? 'Tầng 1',
      ghiChu: json['ghiChu'] ?? json['ghi_chu'],
      ngayTao: json['ngayTao'] != null
          ? DateTime.parse(json['ngayTao'])
          : (json['ngay_tao'] != null
          ? DateTime.parse(json['ngay_tao'])
          : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maBan': maBan,
      'soBan': soBan,
      'trangThai': trangThai,
      'maQR': maQR,
      'viTri': viTri,
      'ghiChu': ghiChu,
      'ngayTao': ngayTao.toIso8601String(),
    };
  }

  // Hiển thị trạng thái tiếng Việt chuẩn
  String get hienThiTrangThai {
    switch (trangThai.toLowerCase()) {
      case 'trống':
        return 'Trống';
      case 'đã có khách':
        return 'Đã có khách';
      case 'bảo trì':
        return 'Bảo trì';
      default:
        return trangThai;
    }
  }

  // Màu theo trạng thái (Color hex)
  int get mauTrangThai {
    switch (trangThai.toLowerCase()) {
      case 'trống':
        return 0xFF4CAF50; // Xanh lá
      case 'đã có khách':
        return 0xFFE53935; // Đỏ
      case 'bảo trì':
        return 0xFF9E9E9E; // Xám
      default:
        return 0xFF9E9E9E;
    }
  }

  // Hiển thị vị trí bàn
  String get hienThiViTri {
    switch (viTri.toLowerCase()) {
      case 'tầng 1':
      case 'tang1':
        return 'Tầng 1';
      case 'tầng 2':
      case 'tang2':
        return 'Tầng 2';
      default:
        return viTri;
    }
  }

  // Kiểm tra bàn trống
  bool get laBanTrong => trangThai == 'Trống';

  // Tạo bản sao có thể thay đổi
  BanAnModel copyWith({
    String? maBan,
    String? soBan,
    String? trangThai,
    String? maQR,
    String? viTri,
    String? ghiChu,
    DateTime? ngayTao,
  }) {
    return BanAnModel(
      maBan: maBan ?? this.maBan,
      soBan: soBan ?? this.soBan,
      trangThai: trangThai ?? this.trangThai,
      maQR: maQR ?? this.maQR,
      viTri: viTri ?? this.viTri,
      ghiChu: ghiChu ?? this.ghiChu,
      ngayTao: ngayTao ?? this.ngayTao,
    );
  }
}
