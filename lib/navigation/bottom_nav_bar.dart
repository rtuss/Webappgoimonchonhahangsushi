import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/menu/menu_list_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/call_staff/call_staff_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _index = 0;

  // 🔥 THÊM KIỂU DỮ LIỆU CHO CHẮC ĂN
  final List<Widget> _tabs = const [
    HomeScreen(),
    MenuListScreen(),
    CartScreen(),
    CallStaffScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu), label: 'Thực đơn'),
          NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined), label: 'Giỏ hàng'),
          NavigationDestination(
              icon: Icon(Icons.support_agent_outlined), label: 'Gọi nhân viên'),
        ],
      ),
    );
  }
}
