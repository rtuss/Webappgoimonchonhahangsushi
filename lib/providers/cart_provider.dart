// 📄 lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../models/gio_hang_model.dart';
import '../models/menu_model.dart';

// 🔹 Thêm 2 import mới
import '../core/services/order_service.dart';
import '../models/donhang_model.dart';

class CartProvider extends ChangeNotifier {
  final List<MonTrongGioModel> _danhSachMon = [];

  List<MonTrongGioModel> get danhSachMon => _danhSachMon;

  // 🛒 Thêm món vào giỏ
  void themMon(MonAnModel monAn) {
    final index = _danhSachMon.indexWhere((e) => e.monAn.id == monAn.id);
    if (index != -1) {
      _danhSachMon[index].soLuong++;
    } else {
      _danhSachMon.add(MonTrongGioModel(monAn: monAn));
    }
    notifyListeners();
  }

  // ➕ Tăng số lượng
  void tangSoLuong(String monId) {
    final index = _danhSachMon.indexWhere((e) => e.monAn.id == monId);
    if (index != -1) {
      _danhSachMon[index].soLuong++;
      notifyListeners();
    }
  }

  // ➖ Giảm số lượng
  void giamSoLuong(String monId) {
    final index = _danhSachMon.indexWhere((e) => e.monAn.id == monId);
    if (index != -1 && _danhSachMon[index].soLuong > 1) {
      _danhSachMon[index].soLuong--;
      notifyListeners();
    }
  }

  // ❌ Xóa món
  void xoaMon(String monId) {
    _danhSachMon.removeWhere((e) => e.monAn.id == monId);
    notifyListeners();
  }

  // 🔄 Clear toàn bộ giỏ hàng
  void clearCart() {
    _danhSachMon.clear();
    notifyListeners();
  }

  // 💰 Tổng tiền gốc (chưa giảm)
  double get tongTien {
    return _danhSachMon.fold<double>(
      0.0,
          (sum, item) => sum + (item.monAn.gia * item.soLuong),
    );
  }

  // 🔻 Tổng giảm giá
  double get tongGiamGia {
    return _danhSachMon.fold<double>(
      0.0,
          (sum, item) {
        final giam = item.monAn.giamGia > 0
            ? (item.monAn.gia * item.soLuong * item.monAn.giamGia / 100)
            : 0.0;
        return sum + giam;
      },
    );
  }

  // ✅ Tổng sau giảm
  double get tongSauGiam => tongTien - tongGiamGia;

  // 🧹 Xóa toàn bộ giỏ
  void xoaTatCa() {
    _danhSachMon.clear();
    notifyListeners();
  }

  // ===============================================================
  // 🚀 HÀM ĐẶT MÓN → TẠO ĐƠN HÀNG + GỬI LÊN BACKEND
  // ===============================================================

  final OrderService _orderService = OrderService(); // dịch vụ API

  /// 🟢 Tạo đơn hàng từ giỏ + gửi lên server
  /// Trả về đơn hàng vừa tạo (hoặc null nếu lỗi)
  Future<DonHangModel?> datMon(int soBan) async {
    if (_danhSachMon.isEmpty) return null;

    final donHang = DonHangModel(
      soBan: soBan,
      danhSachMon: _danhSachMon.map((item) {
        return MonTrongDonModel(
          monAn: item.monAn,
          soLuong: item.soLuong,
          ghiChuDacBiet: item.ghiChuDacBiet,
        );
      }).toList(),
      trangThai: "cho_xac_nhan", // ✅ Trạng thái ban đầu ĐÚNG
    );

    try {
      final ketQua = await _orderService.taoDonHang(donHang);

      if (ketQua != null) {
        // ✅ Xoá giỏ sau khi đặt thành công
        _danhSachMon.clear();
        notifyListeners();
      }

      return ketQua; // ⭐ trả về đơn hàng luôn
    } catch (e) {
      print('❌ Lỗi khi đặt món: $e');
      return null;
    }
  }

}
