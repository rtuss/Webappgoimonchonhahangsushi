class MonAnModel {
  final String id;
  final String tenMon;
  final String moTa;
  final double gia;
  final String loaiMon;
  final String hinhAnh;
  final bool conPhucVu;
  final double giamGia;
  final double danhGia;
  final int soDanhGia;

  MonAnModel({
    required this.id,
    required this.tenMon,
    required this.moTa,
    required this.gia,
    required this.loaiMon,
    required this.hinhAnh,
    this.conPhucVu = true,
    this.giamGia = 0,
    this.danhGia = 0,
    this.soDanhGia = 0,
  });

  // 🧮 Tính giá sau khi giảm
  double get giaSauGiam {
    if (giamGia > 0) {
      return gia * (1 - giamGia / 100);
    }
    return gia;
  }

  // 🟢 Chuyển từ JSON sang Object
  factory MonAnModel.fromJson(Map<String, dynamic> json) {
    return MonAnModel(
      id: json['_id'] ?? json['id'] ?? '',
      tenMon: json['tenMon'] ?? '',
      moTa: json['moTa'] ?? '',
      gia: (json['gia'] ?? 0).toDouble(),
      loaiMon: json['loaiMon'] ?? '',
      hinhAnh: json['hinhAnh'] ?? '',
      conPhucVu: json['conPhucVu'] ?? true,
      giamGia: (json['giamGia'] ?? 0).toDouble(),
      danhGia: (json['danhGia'] ?? 0).toDouble(),
      soDanhGia: json['soDanhGia'] ?? 0,
    );
  }

  // 🔵 Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tenMon': tenMon,
      'moTa': moTa,
      'gia': gia,
      'loaiMon': loaiMon,
      'hinhAnh': hinhAnh,
      'conPhucVu': conPhucVu,
      'giamGia': giamGia,
      'danhGia': danhGia,
      'soDanhGia': soDanhGia,
    };
  }
}