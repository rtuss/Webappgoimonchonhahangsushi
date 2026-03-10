import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../models/nguoi_dung_model.dart';

class AuthService {
  final Dio _dio = Dio();

  // 🟢 Đăng ký
  Future<Map<String, dynamic>> register({
    required String tenDangNhap,
    required String matKhau,
    required String email,
    required String hoTen,
    required String soDienThoai,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/register',
        data: {
          'tenDangNhap': tenDangNhap,
          'matKhau': matKhau,
          'email': email,
          'hoTen': hoTen,
        },
      );

      return {
        'success': true,
        'user': NguoiDungModel.fromJson(response.data),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi khi đăng ký: $e',
      };
    }
  }

  // 🟢 Đăng nhập
  Future<Map<String, dynamic>> login({
    required String tenDangNhap,
    required String matKhau,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/login',
        data: {
          'tenDangNhap': tenDangNhap,
          'matKhau': matKhau,
        },
      );

      return {
        'success': true,
        'user': NguoiDungModel.fromJson(response.data['user']),
        'token': response.data['token'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Sai thông tin đăng nhập hoặc lỗi server: $e',
      };
    }

  }
  // ================== HÀM BỔ SUNG ==================

// 🟢 Kiểm tra người dùng đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    // Ở đây chỉ cần kiểm tra xem có token trong storage hay không
    // Nếu dùng SharedPreferences thì có thể sửa sau
    return false; // Mặc định chưa có login
  }

// 🟢 Lấy thông tin người dùng hiện tại
  Future<NguoiDungModel?> getCurrentUser() async {
    // Ở bước đầu tiên có thể tạm return null
    // Sau này khi có lưu user vào SharedPreferences, sẽ lấy ra tại đây
    return null;
  }

// 🟢 Đăng xuất
  Future<void> logout() async {
    // Nếu có lưu token hoặc user trong SharedPreferences thì xoá ở đây
    // Giờ chưa có, nên chỉ cần return thôi
    return;
  }

}
