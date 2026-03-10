import 'package:flutter/material.dart';

class TrangThaiBadge extends StatelessWidget {
  final String status;

  const TrangThaiBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case "cho_xac_nhan":
        color = Colors.orange;
        text = "Chờ xác nhận";
        break;

      case "da_xac_nhan":
        color = Colors.blueGrey;
        text = "Đã xác nhận";
        break;

      case "dang_che_bien":
        color = Colors.blue;
        text = "Đang chế biến";
        break;

      case "bep_hoan_tat":
        color = Colors.green;
        text = "Bếp hoàn tất";
        break;

      case "da_giao_mon":
        color = Colors.teal;
        text = "Đã giao món";
        break;

      case "yeu_cau_thanh_toan":
        color = Colors.amber;
        text = "Yêu cầu thanh toán";
        break;

      case "da_thanh_toan":
        color = Colors.green;
        text = "✅ Hoàn tất";
        break;

      default:
        color = Colors.grey;
        text = "Không rõ";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 14,
        ),
      ),
    );
  }
}
