// 📄 lib/models/gio_hang_model.dart
import '../models/menu_model.dart';

/// 🔹 Mô hình dữ liệu cho một món trong giỏ hàng
class MonTrongGioModel {
  final MonAnModel monAn;      // 🍣 Món ăn (đối tượng từ menu)
  int soLuong;                 // 🔢 Số lượng
  String? ghiChuDacBiet;       // 📝 Ghi chú đặc biệt

  MonTrongGioModel({
    required this.monAn,
    this.soLuong = 1,
    this.ghiChuDacBiet,
  });

  /// 💰 Tổng tiền của món trong giỏ
  double get tongTien {
    return monAn.giaSauGiam * 1000 * soLuong;
  }

  /// ⭐ Tạo bản sao với một vài field thay đổi
  MonTrongGioModel copyWith({
    MonAnModel? monAn,
    int? soLuong,
    String? ghiChuDacBiet,
  }) {
    return MonTrongGioModel(
      monAn: monAn ?? this.monAn,
      soLuong: soLuong ?? this.soLuong,
      ghiChuDacBiet: ghiChuDacBiet ?? this.ghiChuDacBiet,
    );
  }

  /// ⭐ Dùng khi gửi API tạo đơn hàng
  Map<String, dynamic> toJson() {
    return {
      'monAn': monAn.toJson(),           // gửi full object món ăn
      'soLuong': soLuong,
      'ghiChuDacBiet': ghiChuDacBiet ?? '',
    };
  }

  /// ⭐ Dùng nếu backend trả lại giỏ / đơn hàng có chứa món
  factory MonTrongGioModel.fromJson(Map<String, dynamic> json) {
    return MonTrongGioModel(
      monAn: MonAnModel.fromJson(json['monAn']),  // ✅ chỉ dùng fromJson, KHÔNG fromId nữa
      soLuong: json['soLuong'] ?? 1,
      ghiChuDacBiet: json['ghiChuDacBiet'],
    );
  }
}
