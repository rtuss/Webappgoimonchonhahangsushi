import 'package:flutter/material.dart';
import '../models/donhang_model.dart';
import '../core/services/order_service.dart';
import '../core/services/socket_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  final SocketService _socketService = SocketService();

  List<DonHangModel> danhSach = [];
  bool isLoading = false;
  int? _currentSoBan;

  // 📍 Getter để lấy số bàn hiện tại
  int? get currentSoBan => _currentSoBan;

  OrderProvider() {
    // Listen to socket updates
    _socketService.onOrderUpdated = (data) {
      print('🔔 Socket update received: $data');
      if (_currentSoBan != null) {
        loadDonHang(_currentSoBan!);
      }
    };
    _socketService.connect();
  }

  Future<void> loadDonHang(int soBan) async {
    _currentSoBan = soBan;
    isLoading = true;
    notifyListeners();

    try {
      danhSach = await _service.getDonTheoBan(soBan);   // ⭐ list đã đúng format
      print("📦 Loaded ${danhSach.length} orders for bàn $soBan");
    } catch (e) {
      print("❌ Error loading orders: $e");
      danhSach = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateTrangThai(String id, String status) async {
    await _service.capNhatTrangThai(id, status);

    final idx = danhSach.indexWhere((d) => d.id == id);
    if (idx != -1) {
      danhSach[idx] = danhSach[idx].copyWith(trangThai: status);
    }
    notifyListeners();
  }

  // 🔄 Clear tất cả đơn hàng
  void clearOrders() {
    danhSach.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}
