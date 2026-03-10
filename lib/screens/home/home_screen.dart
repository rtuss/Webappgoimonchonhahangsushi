import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../menu/menu_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _banners = const [
    'https://i.pinimg.com/736x/f0/ff/18/f0ff18bbcee972f472447c85c93b910e.jpg',
    'https://i.pinimg.com/736x/09/07/25/0907256e44d0e1ea0c5cdbf81e12779b.jpg',
    'https://i.pinimg.com/1200x/24/be/1d/24be1d4db32e73415b442a039b08523a.jpg',
  ];

  final _page = PageController(viewportFraction: 0.9);
  int _current = 0;
  int _lastLoadedBan = 0;

  @override
  void initState() {
    super.initState();
    // 📥 Load orders của bàn này khi vừa vào HomeScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuProvider = context.read<MenuProvider>();
      final orderProvider = context.read<OrderProvider>();
      final soBan = menuProvider.tableNumber;
      
      if (soBan > 0) {
        print("📥 Loading orders for bàn: $soBan");
        orderProvider.loadDonHang(soBan);
        _lastLoadedBan = soBan;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔄 Nếu bàn thay đổi, reload orders
    final menuProvider = context.read<MenuProvider>();
    final orderProvider = context.read<OrderProvider>();
    final soBan = menuProvider.tableNumber;
    
    if (soBan > 0 && soBan != _lastLoadedBan) {
      print("🔄 Bàn thay đổi: $_lastLoadedBan → $soBan, reload orders");
      orderProvider.loadDonHang(soBan);
      _lastLoadedBan = soBan;
    }
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProv = context.watch<MenuProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/sushi_logo.jpg', height: 55),
            const SizedBox(width: 10),
            Text(
              'Rtuss Sushi',
              style: GoogleFonts.dancingScript(
                textStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // 🔄 Nút quay lại chọn bàn
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.redAccent),
            onPressed: () {
              // 🟡 Clear cart + orders trước, rồi quay lại table_number_screen
              final cartProvider = context.read<CartProvider>();
              final orderProvider = context.read<OrderProvider>();
              
              cartProvider.clearCart();
              orderProvider.clearOrders();
              
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/table',
                (route) => false, // Clear tất cả routes, về root
              );
            },
            tooltip: 'Chọn lại bàn',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async => menuProv.loadMenu(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🖼 Banner trượt
              SizedBox(
                height: 170,
                child: PageView.builder(
                  controller: _page,
                  itemCount: _banners.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        _banners[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ⚪ Chấm trượt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_banners.length, (i) {
                  final active = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 14 : 8,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? Colors.redAccent : Colors.black26,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 🍱 Tiêu đề
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Danh mục món ăn",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🧭 Danh mục
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCategoryCard(
                      title: "Sushi",
                      color: Colors.orangeAccent,
                      image: "assets/icons/sushi.jpg",
                      onTap: () => _openMenu(context, "Sushi"),
                    ),
                    _buildCategoryCard(
                      title: "Sashimi",
                      color: Colors.teal,
                      image: "assets/icons/sashimi.jpg",
                      onTap: () => _openMenu(context, "Sashimi"),
                    ),
                    _buildCategoryCard(
                      title: "Set Combo",
                      color: Colors.deepOrangeAccent,
                      image: "assets/icons/combo.jpg",
                      onTap: () => _openMenu(context, "Set combo"),
                    ),
                    _buildCategoryCard(
                      title: "Tempura",
                      color: Colors.purpleAccent,
                      image: "assets/icons/tempura.jpg",
                      onTap: () => _openMenu(context, "Tempura"),
                    ),
                    _buildCategoryCard(
                      title: "Salad",
                      color: Colors.green,
                      image: "assets/icons/salad.jpg",
                      onTap: () => _openMenu(context, "Salad"),
                    ),
                    _buildCategoryCard(
                      title: "Đồ uống",
                      color: Colors.blueAccent,
                      image: "assets/icons/drink.jpg",
                      onTap: () => _openMenu(context, "Đồ uống"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🌿 Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "© 2025 Rtuss Sushi — Trải nghiệm ẩm thực Nhật Bản tại bàn.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuListScreen(initialCategory: category),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required Color color,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
