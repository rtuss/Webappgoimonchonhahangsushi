import 'package:flutter/material.dart';

/// 🎯 Widget hiển thị thông tin thanh toán VietQR (phiên bản đơn giản + mượt)
/// Khách tự nhập vào app ngân hàng
class VietQRSimpleWidget extends StatelessWidget {
  final double amount;
  final String accountNumber;
  final String bankName;
  final String description;

  const VietQRSimpleWidget({
    super.key,
    required this.amount,
    required this.accountNumber,
    this.bankName = "Vietcombank",
    required this.description,
  });

  /// 🔹 Format tiền tệ
  String _formatCurrency(double amount) {
    int displayAmount = amount.toInt();
    return displayAmount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[300]!, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Tiêu đề
            const Text(
              "💳 Chuyển khoản Vietcombank",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // 📋 Thông tin chi tiết
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Số tiền
                  _buildInfoRow("Số tiền:", "${_formatCurrency(amount)}đ", Colors.redAccent),
                  const SizedBox(height: 10),
                  
                  // Nội dung
                  _buildInfoRow("Nội dung:", description, Colors.teal),
                  const SizedBox(height: 10),
                  
                  // Tài khoản
                  _buildInfoRow("Tài khoản:", accountNumber, Colors.blue),
                  const SizedBox(height: 10),
                  
                  // Ngân hàng
                  _buildInfoRow("Ngân hàng:", bankName, Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget hiển thị một dòng thông tin
  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
