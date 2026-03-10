import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/menu_provider.dart';
import '../../models/menu_model.dart';
import '../../widgets/menu/menu_card.dart';

class MenuListScreen extends StatefulWidget {
  final String? initialCategory; //  nhận danh mục từ HomeScreen (optional)

  const MenuListScreen({super.key, this.initialCategory});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  String _selectedCategory = 'Tất cả';
  List<MonAnModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final menuProv = Provider.of<MenuProvider>(context, listen: false);
      await menuProv.loadMenu();

      final all = menuProv.menuItems;

      // Nếu từ HomeScreen truyền vào 1 danh mục cụ thể
      if (widget.initialCategory != null &&
          widget.initialCategory!.isNotEmpty &&
          widget.initialCategory != 'Tất cả') {
        _selectedCategory = widget.initialCategory!;
        _filteredItems =
            all.where((e) => e.loaiMon == widget.initialCategory).toList();
      } else {
        // Mặc định: hiển thị tất cả
        _filteredItems = all;
      }

      if (mounted) setState(() {});
    });
  }

  void _filterByCategory(String category, List<MonAnModel> allItems) {
    setState(() {
      _selectedCategory = category;
      if (category == 'Tất cả') {
        _filteredItems = allItems;
      } else {
        _filteredItems =
            allItems.where((item) => item.loaiMon == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuProv = context.watch<MenuProvider>();
    final allItems = menuProv.menuItems;
    final formatCurrency = NumberFormat('#,###', 'vi_VN'); // nếu cần dùng

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Icon(Icons.restaurant_menu, color: Colors.orangeAccent),
            const SizedBox(width: 8),
            Text(
              _selectedCategory == 'Tất cả'
                  ? "Thực đơn nhà hàng"
                  : "Danh mục: $_selectedCategory",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),

      // ========== BODY ==========
      body: menuProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Thanh filter danh mục
          SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                for (final cat in const [
                  'Tất cả',
                  'Sushi',
                  'Sashimi',
                  'Set combo',
                  'Tempura',
                  'Salad',
                  'Đồ uống'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: _selectedCategory == cat,
                      onSelected: (_) =>
                          _filterByCategory(cat, allItems),
                      selectedColor: Colors.tealAccent.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Lưới món ăn
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
              child: Text('Không có món nào trong mục này.'),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              child: GridView.builder(
                itemCount: _filteredItems.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //  2 cột
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65, //  tăng để card cao hơn
                ),
                itemBuilder: (context, index) {
                  final MonAnModel mon = _filteredItems[index];
                  return MenuCard(item: mon);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
