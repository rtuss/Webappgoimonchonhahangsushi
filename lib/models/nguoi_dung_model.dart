// lib/models/nguoi_dung_model.dart

class NguoiDungModel {
  final String maNguoiDung;
  final String tenDangNhap;
  final String email;
  final String hoTen;
  final String soDienThoai;
  final String vaiTro;
  final String? anhDaiDien;
  final bool dangHoatDong;
  final bool daDuocDuyet;

  NguoiDungModel({
    required this.maNguoiDung,
    required this.tenDangNhap,
    required this.email,
    required this.hoTen,
    required this.soDienThoai,
    required this.vaiTro,
    this.anhDaiDien,
    required this.dangHoatDong,
    required this.daDuocDuyet,
  });

  /// Tạo object từ JSON (Map)
  factory NguoiDungModel.fromJson(Map<String, dynamic> json) {
    return NguoiDungModel(
      maNguoiDung: json['maNguoiDung'] ?? json['_id'] ?? '',
      tenDangNhap: json['tenDangNhap'] ?? '',
      email: json['email'] ?? '',
      hoTen: json['hoTen'] ?? '',
      soDienThoai: json['soDienThoai'] ?? '',
      vaiTro: json['vaiTro'] ?? 'KHACHHANG',
      anhDaiDien: json['anhDaiDien'],
      dangHoatDong: json['dangHoatDong'] ?? true,
      daDuocDuyet: json['daDuocDuyet'] ?? false,
    );
  }

  /// Chuyển object thành JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'maNguoiDung': maNguoiDung,
      'tenDangNhap': tenDangNhap,
      'email': email,
      'hoTen': hoTen,
      'soDienThoai': soDienThoai,
      'vaiTro': vaiTro,
      'anhDaiDien': anhDaiDien,
      'dangHoatDong': dangHoatDong,
      'daDuocDuyet': daDuocDuyet,
    };
  }

  /// Tạo bản sao và cho phép thay đổi một số trường
  NguoiDungModel copyWith({
    String? maNguoiDung,
    String? tenDangNhap,
    String? email,
    String? hoTen,
    String? soDienThoai,
    String? vaiTro,
    String? anhDaiDien,
    bool? dangHoatDong,
    bool? daDuocDuyet,
  }) {
    return NguoiDungModel(
      maNguoiDung: maNguoiDung ?? this.maNguoiDung,
      tenDangNhap: tenDangNhap ?? this.tenDangNhap,
      email: email ?? this.email,
      hoTen: hoTen ?? this.hoTen,
      soDienThoai: soDienThoai ?? this.soDienThoai,
      vaiTro: vaiTro ?? this.vaiTro,
      anhDaiDien: anhDaiDien ?? this.anhDaiDien,
      dangHoatDong: dangHoatDong ?? this.dangHoatDong,
      daDuocDuyet: daDuocDuyet ?? this.daDuocDuyet,
    );
  }
}
