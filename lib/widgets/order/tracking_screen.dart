import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/order_provider.dart';
import '../../widgets/order/order_timeline.dart';
import '../../widgets/order/trang_thai_badge.dart';
import '../../widgets/payment/viet_qr_simple_widget.dart';

class TrackingScreen extends StatefulWidget {
  final int soBan;

  const TrackingScreen({super.key, required this.soBan});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Timer? _timer;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();

    // Đợi build xong mới được gọi provider
    Future.microtask(() {
      final provider = Provider.of<OrderProvider>(context, listen: false);

      // Load đơn hàng lần đầu
      provider.loadDonHang(widget.soBan);

      // Auto refresh mỗi 3 giây
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        provider.loadDonHang(widget.soBan);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi thoát trang
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          print("⬅️ Back từ Tracking Screen - giữ nguyên trạng thái!");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Theo dõi đơn hàng"),
          centerTitle: true,
        ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.danhSach.isEmpty
          ? const Center(
        child: Text(
          "Chưa có đơn hàng nào",
          style: TextStyle(fontSize: 16),
        ),
      )
          : Stack(
        children: [
          ListView.builder(
            padding: provider.danhSach.isNotEmpty && (provider.danhSach.first.trangThai == "da_giao_mon" || provider.danhSach.first.trangThai == "yeu_cau_thanh_toan")
                ? const EdgeInsets.fromLTRB(16, 16, 16, 100)
                : const EdgeInsets.all(16),
            itemCount: 1,

            itemBuilder: (context, index) {
              final don = provider.danhSach.first;


          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔸 Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bàn số ${don.soBan}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TrangThaiBadge(status: don.trangThai),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔸 Timeline
                  OrderTimeline(status: don.trangThai),

                  const SizedBox(height: 20),



                  /// 🟢 PHƯƠNG THỨC THANH TOÁN (CHỈ HIỂN THỊ KHI BẤM NÚT THANH TOÁN)
                  if ((_selectedPaymentMethod == "show_payment" || _selectedPaymentMethod == "viet_qr" || _selectedPaymentMethod == "tien_mat") && (don.trangThai == "da_giao_mon" || don.trangThai == "yeu_cau_thanh_toan")) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange[50]!, Colors.orange[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange[200]!, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "💳 Chọn phương thức thanh toán:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // ===== PHƯƠNG THỨC THANH TOÁN =====
                          // Option 1: Tiền mặt
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPaymentMethod = (_selectedPaymentMethod == "tien_mat") ? "show_payment" : "tien_mat";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (_selectedPaymentMethod == "tien_mat")
                                      ? Colors.teal
                                      : Colors.grey[300]!,
                                  width: (_selectedPaymentMethod == "tien_mat") ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: (_selectedPaymentMethod == "tien_mat")
                                    ? Colors.teal[50]
                                    : Colors.white,
                                boxShadow: [
                                  if (_selectedPaymentMethod == "tien_mat")
                                    BoxShadow(
                                      color: Colors.teal.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text("💵", style: TextStyle(fontSize: 28)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Tiền mặt",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Thanh toán ngay tại quầy",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedPaymentMethod == "tien_mat")
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.teal,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // Option 2: VietQR
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPaymentMethod = "viet_qr";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (_selectedPaymentMethod == "viet_qr")
                                      ? Colors.teal
                                      : Colors.grey[300]!,
                                  width: (_selectedPaymentMethod == "viet_qr") ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: (_selectedPaymentMethod == "viet_qr")
                                    ? Colors.teal[50]
                                    : Colors.white,
                                boxShadow: [
                                  if (_selectedPaymentMethod == "viet_qr")
                                    BoxShadow(
                                      color: Colors.teal.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.purple[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text("📱", style: TextStyle(fontSize: 28)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "VietQR",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Quét mã QR và thanh toán",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedPaymentMethod == "viet_qr")
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.teal,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // 🟢 HIỂN THỊ THÔNG TIN THANH TOÁN VIETQR KHI CHỌN
                          if (_selectedPaymentMethod == "viet_qr") ...[
                            const SizedBox(height: 16),
                            VietQRSimpleWidget(
                              amount: don.tongTien.toDouble(), // Don.tongTien đã là VND
                              accountNumber: "1032886800", // VietcomBank - tài khoản thật
                              bankName: "Vietcombank",
                              description: "Thanh toan ban ${don.soBan}",
                            ),
                          ],
                          // Nút xác nhận
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (_selectedPaymentMethod != "tien_mat" && _selectedPaymentMethod != "viet_qr")
                                  ? null
                                  : () {
                                final paymentLabel = _selectedPaymentMethod == "tien_mat"
                                    ? "Tiền mặt"
                                    : "VietQR";
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "✅ Đã chọn: $paymentLabel\nVui lòng chờ nhân viên xác nhận",
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                disabledBackgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Xác nhận thanh toán",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// 🟢 THÔNG BÁO HOÀN TẤT (KHI TRẠNG THÁI = "HOÀN TẤT")
                  if (don.trangThai == "hoan_tat") ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "✓ Đã cấp nhật: Yêu cầu thanh toán",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
            },
          ),
          // ===== NÚT THANH TOÁN PHÍA DƯỚI =====
          if (provider.danhSach.isNotEmpty && (provider.danhSach.first.trangThai == "da_giao_mon" || provider.danhSach.first.trangThai == "yeu_cau_thanh_toan"))
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPaymentMethod = "show_payment";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "💳 Thanh toán",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
