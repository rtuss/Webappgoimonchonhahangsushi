import 'package:flutter/material.dart';

class OrderTimeline extends StatelessWidget {
  final String status;

  const OrderTimeline({super.key, required this.status});

  Widget _buildStep({
    required bool active,
    required String title,
    required IconData icon,
    required Color activeColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active ? activeColor : Colors.grey.shade300,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: active ? activeColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chỉ hiển thị rõ các bước đã đạt tới, các bước sau mờ/xám
    bool step1 = status == "cho_xac_nhan" ||
        status == "da_xac_nhan" ||
        status == "dang_che_bien" ||
        status == "bep_hoan_tat" ||
        status == "da_giao_mon";

    bool step2 = status == "da_xac_nhan" ||
        status == "dang_che_bien" ||
        status == "bep_hoan_tat" ||
        status == "da_giao_mon";

    bool step3 = status == "dang_che_bien" ||
        status == "bep_hoan_tat" ||
        status == "da_giao_mon";

    bool step4 = status == "bep_hoan_tat" ||
        status == "da_giao_mon";

    bool step5 = status == "da_giao_mon";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStep(
          active: step1,
          title: "Chờ xác nhận",
          icon: Icons.timer,
          activeColor: Colors.orange,
        ),
        _line(step2),

        _buildStep(
          active: step2,
          title: "Đã xác nhận",
          icon: Icons.verified,
          activeColor: Colors.blueGrey,
        ),
        _line(step3),

        _buildStep(
          active: step3,
          title: "Bếp đang chế biến",
          icon: Icons.local_fire_department,
          activeColor: Colors.blue,
        ),
        _line(step4),

        _buildStep(
          active: step4,
          title: "Bếp hoàn tất",
          icon: Icons.check_circle,
          activeColor: Colors.green,
        ),
        _line(step5),

        _buildStep(
          active: step5,
          title: "Đã giao món",
          icon: Icons.delivery_dining,
          activeColor: Colors.teal,
        ),
      ],
    );
  }

  Widget _line(bool active) {
    return Container(
      height: 30,
      width: 2,
      margin: const EdgeInsets.only(left: 16),
      color: active ? Colors.green : Colors.grey.shade300,
    );
  }
}
