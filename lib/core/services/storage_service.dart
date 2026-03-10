// Lưu trữ mỗi lần đăng nhập
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/nguoi_dung_model.dart';

class StorageService {
  static const _userKey = 'nguoi_dung';

  Future<void> saveUser(NguoiDungModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<NguoiDungModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr != null) {
      return NguoiDungModel.fromJson(jsonDecode(jsonStr));
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
