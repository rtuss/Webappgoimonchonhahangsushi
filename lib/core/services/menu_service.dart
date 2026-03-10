import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../models/menu_model.dart';

class MenuService {
  final Dio _dio = Dio();

  // Lấy danh sách món ăn
  Future<List<MonAnModel>> fetchMenu() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/menu');
      final data = response.data as List;
      return data.map((e) => MonAnModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Không thể tải menu: $e');
    }
  }
}
