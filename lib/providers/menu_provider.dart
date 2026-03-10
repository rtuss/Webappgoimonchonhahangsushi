import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../core/services/menu_service.dart';
import '../models/menu_model.dart';

class MenuProvider with ChangeNotifier {
  final MenuService _service = MenuService();
  List<MonAnModel> _menuItems = [];
  bool _isLoading = false;
  late IO.Socket _socket;
  int _tableNumber = 0;

  List<MonAnModel> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  int get tableNumber => _tableNumber;

  MenuProvider() {
    _initSocket();
  }

  void _initSocket() {
    try {
      _socket = IO.io('http://localhost:3000', 
        IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build()
      );

      _socket.on('connect', (_) {
        print('✅ Socket connected');
      });

      // Lắng nghe sự kiện menu được cập nhật
      _socket.on('menuUpdated', (data) {
        _handleMenuUpdate(data);
      });

      _socket.connect();
    } catch (e) {
      print('❌ Socket error: $e');
    }
  }

  void _handleMenuUpdate(dynamic data) {
    final action = data['action'];
    final menuItem = MonAnModel.fromJson(data['menuItem']);

    if (action == 'add') {
      // Thêm menu mới
      _menuItems.add(menuItem);
      print('📢 Menu added: ${menuItem.tenMon}');
    } else if (action == 'update') {
      // Cập nhật menu
      final index = _menuItems.indexWhere((m) => m.id == menuItem.id);
      if (index != -1) {
        _menuItems[index] = menuItem;
        print('📢 Menu updated: ${menuItem.tenMon}');
      }
    } else if (action == 'delete') {
      // Xóa menu
      _menuItems.removeWhere((m) => m.id == menuItem.id);
      print('📢 Menu deleted: ${menuItem.tenMon}');
    }

    notifyListeners();
  }

  Future<void> loadMenu() async {
    _isLoading = true;
    notifyListeners();
    try {
      _menuItems = await _service.fetchMenu();
    } catch (e) {
      _menuItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTableNumber(int tableNum) {
    _tableNumber = tableNum;
    notifyListeners();
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
