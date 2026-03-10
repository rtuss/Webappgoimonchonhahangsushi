// 📄 lib/models/chat_model.dart

/// 🔹 Mô hình tin nhắn trong hệ thống (khách ↔ nhân viên ↔ bếp)
class TinNhanModel {
  final String id; // Mã tin nhắn
  final String nguoiGui; // ID người gửi
  final String nguoiNhan; // ID người nhận
  final String noiDung; // Nội dung tin nhắn
  final String loai; // Loại tin nhắn (văn bản, hình ảnh, âm thanh,…)
  final String? maBan; // Bàn liên quan (nếu có)
  final String vaiTroNguoiGui; // Vai trò người gửi (khach, nhan_vien, bep)
  final bool daDoc; // Tin nhắn đã đọc chưa
  final DateTime ngayGui; // Thời điểm gửi
  final DateTime? ngayDoc; // Thời điểm đọc

  TinNhanModel({
    required this.id,
    required this.nguoiGui,
    required this.nguoiNhan,
    required this.noiDung,
    this.loai = 'van_ban',
    this.maBan,
    required this.vaiTroNguoiGui,
    this.daDoc = false,
    required this.ngayGui,
    this.ngayDoc,
  });

  // 🧩 Factory khởi tạo từ JSON
  factory TinNhanModel.fromJson(Map<String, dynamic> json) {
    return TinNhanModel(
      id: json['_id'] ?? json['id'] ?? '',
      nguoiGui: json['nguoiGui'] ?? json['sender'] ?? '',
      nguoiNhan: json['nguoiNhan'] ?? json['receiver'] ?? '',
      noiDung: json['noiDung'] ?? json['message'] ?? '',
      loai: json['loai'] ?? json['type'] ?? 'van_ban',
      maBan: json['maBan'] ?? json['table'],
      vaiTroNguoiGui:
      json['vaiTroNguoiGui'] ?? json['role'] ?? 'khach', // mặc định khách
      daDoc: json['daDoc'] ?? json['isRead'] ?? false,
      ngayGui: json['ngayGui'] != null
          ? DateTime.parse(json['ngayGui'])
          : (json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now()),
      ngayDoc: json['ngayDoc'] != null
          ? DateTime.parse(json['ngayDoc'])
          : (json['readAt'] != null
          ? DateTime.parse(json['readAt'])
          : null),
    );
  }

  // 🧾 Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nguoiGui': nguoiGui,
      'nguoiNhan': nguoiNhan,
      'noiDung': noiDung,
      'loai': loai,
      'maBan': maBan,
      'vaiTroNguoiGui': vaiTroNguoiGui,
      'daDoc': daDoc,
      'ngayGui': ngayGui.toIso8601String(),
      'ngayDoc': ngayDoc?.toIso8601String(),
    };
  }

  // 🗨️ Tạo nhanh một tin nhắn mới để gửi
  static Map<String, dynamic> taoTinNhan({
    required String noiDung,
    required String nguoiGui,
    required String nguoiNhan,
    required String vaiTroNguoiGui,
    String loai = 'van_ban',
    String? maBan,
    String? maDonHang,
  }) {
    return {
      'noiDung': noiDung,
      'nguoiGui': nguoiGui,
      'nguoiNhan': nguoiNhan,
      'vaiTroNguoiGui': vaiTroNguoiGui,
      'loai': loai,
      if (maBan != null) 'maBan': maBan,
      'ngayGui': DateTime.now().toIso8601String(),
    };
  }

  // ⏰ Hiển thị thời gian gửi thân thiện
  String get hienThiThoiGian {
    final now = DateTime.now();
    final diff = now.difference(ngayGui);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${ngayGui.day}/${ngayGui.month}/${ngayGui.year}';
  }

  // ✅ Kiểm tra xem tin nhắn này có phải của người hiện tại hay không
  bool laTinNhanCuaToi(String maNguoiDungHienTai) {
    return nguoiGui == maNguoiDungHienTai;
  }

  // 🧩 Tạo bản sao có thể chỉnh sửa
  TinNhanModel copyWith({
    String? id,
    String? nguoiGui,
    String? nguoiNhan,
    String? noiDung,
    String? loai,
    String? maBan,
    String? vaiTroNguoiGui,
    bool? daDoc,
    DateTime? ngayGui,
    DateTime? ngayDoc,
  }) {
    return TinNhanModel(
      id: id ?? this.id,
      nguoiGui: nguoiGui ?? this.nguoiGui,
      nguoiNhan: nguoiNhan ?? this.nguoiNhan,
      noiDung: noiDung ?? this.noiDung,
      loai: loai ?? this.loai,
      maBan: maBan ?? this.maBan,
      vaiTroNguoiGui: vaiTroNguoiGui ?? this.vaiTroNguoiGui,
      daDoc: daDoc ?? this.daDoc,
      ngayGui: ngayGui ?? this.ngayGui,
      ngayDoc: ngayDoc ?? this.ngayDoc,
    );
  }
}
