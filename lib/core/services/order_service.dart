import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../models/donhang_model.dart';

class OrderService {
  final Dio _dio = Dio();

  /// 🟢 Tạo đơn hàng (KHÁCH)
  Future<DonHangModel> taoDonHang(DonHangModel don) async {
    final res = await _dio.post(
      "${ApiConstants.baseUrl}/orders",   // ĐÚNG API
      data: don.toJson(),
    );

    return DonHangModel.fromJson(res.data["data"]);
  }

  /// 🟡 Cập nhật trạng thái (Chỉ nhân viên)
  Future<void> capNhatTrangThai(String id, String status) async {
    await _dio.patch(
      "${ApiConstants.baseUrl}/staff/orders/$id/status",
      data: {"trangThai": status},
    );
  }

  /// 🔵 Lấy đơn theo bàn (KHÁCH xem)
  Future<List<DonHangModel>> getDonTheoBan(int soBan) async {
    try {
      final res = await _dio.get(
        "${ApiConstants.baseUrl}/orders/table/$soBan",
      );

      final list = (res.data["data"] as List?) ?? [];
      return list
          .map((e) => DonHangModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Lỗi lấy đơn theo bàn: $e');
      rethrow;
    }
  }
}
