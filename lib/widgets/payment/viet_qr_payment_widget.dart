import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 🎯 Widget hiển thị QR Code VietQR để thanh toán chuyển khoản
class VietQRPaymentWidget extends StatelessWidget {
  final double amount;
  final String accountNumber;
  final String bankCode;
  final String templateId;
  final String description;

  const VietQRPaymentWidget({
    super.key,
    required this.amount,
    this.accountNumber = "1234567890", // Số tài khoản mặc định
    this.bankCode = "970401", // Mã ngân hàng (VietcomBank)
    this.templateId = "compact",
    required this.description, // Nội dung chuyển khoản (VD: "Thanh toan ban 5")
  });

  /// 🔹 Format tiền tệ đúng
  String _formatCurrency(double amount) {
    // Amount đã là VND (VD: 303100), chỉ cần format hiển thị
    int displayAmount = amount.toInt();
    
    // Format với dấu chấm phân cách
    return displayAmount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
  }

  /// 🔹 Tạo chuỗi QR Code theo chuẩn VietQR
  /// Format: VIETQR://account/bankcode/amount/description
  /// Ví dụ: VIETQR://1032886800/970401/50000/Thanh%20toan%20ban%205
  String _generateVietQRString() {
    // Amount đã là VND
    int amountInVND = amount.toInt();
    
    // Encode nội dung chuyển khoản
    String encodedDescription = Uri.encodeComponent(description);
    
    // Format VIETQR (không cần NAPAS API registration)
    String qrData = "VIETQR://${accountNumber.replaceAll(' ', '')}"
        "/$bankCode"
        "/$amountInVND"
        "/$encodedDescription";
    
    // 🔍 Debug logging
    print("🔵 VietQR Data: $qrData");
    
    return qrData;
  }

  @override
  Widget build(BuildContext context) {
    final qrData = _generateVietQRString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 📌 Tiêu đề
          const Text(
            "💳 Thanh toán qua VietQR",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Số tiền:",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${_formatCurrency(amount)}đ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nội dung:",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tài khoản:",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      accountNumber,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 📱 QR Code - Optimize render
          RepaintBoundary(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
                gapless: false,
                embeddedImage: null,
                errorStateBuilder: (ctx, err) {
                  return Container(
                    color: Colors.red[100],
                    child: const Center(
                      child: Text("❌ QR Code Error"),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 📲 Hướng dẫn
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📲 Hướng dẫn:",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "1. Mở ứng dụng ngân hàng hoặc ứng dụng hỗ trợ VietQR\n"
                  "2. Chọn 'Quét mã QR' hoặc 'Chuyển tiền QR'\n"
                  "3. Quét mã QR ở trên\n"
                  "4. Kiểm tra thông tin và xác nhận thanh toán",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ⚠️ Lưu ý
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.orange,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Sau khi thanh toán thành công, hãy bấm 'Xác nhận thanh toán' phía dưới",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
