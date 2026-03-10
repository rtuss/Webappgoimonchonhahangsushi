import 'package:flutter/material.dart';
import '../models/nguoi_dung_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();

  NguoiDungModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  NguoiDungModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  // 🔹 Khởi tạo - kiểm tra người dùng đã đăng nhập hay chưa
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _user = await _storage.getUser();
        final freshUser = await _authService.getCurrentUser();
        if (freshUser != null) {
          _user = freshUser;
        }
      }
    } catch (e) {
      print('Initialize error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Đăng nhập
  Future<bool> login({
    required String tenDangNhap,
    required String matKhau,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        tenDangNhap: tenDangNhap,
        matKhau: matKhau,
      );

      if (result['success']) {
        _user = result['nguoiDung'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng nhập';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔹 Đăng ký
  Future<bool> register({
    required String tenDangNhap,
    required String email,
    required String matKhau,
    required String hoTen,
    required String soDienThoai,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        tenDangNhap: tenDangNhap,
        email: email,
        matKhau: matKhau,
        hoTen: hoTen,
        soDienThoai: soDienThoai,
      );

      if (result['success']) {
        _user = result['nguoiDung'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng ký';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔹 Đăng xuất
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  // 🔹 Xóa lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
