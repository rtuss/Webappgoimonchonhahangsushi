import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/chat_provider.dart';

class TableNumberScreen extends StatefulWidget {
  const TableNumberScreen({super.key});

  @override
  State<TableNumberScreen> createState() => _TableNumberScreenState();
}

class _TableNumberScreenState extends State<TableNumberScreen> {
  late TextEditingController _tableController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tableController = TextEditingController();
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  void _submitTableNumber() {
    final tableNumber = _tableController.text.trim();

    // Validate
    if (tableNumber.isEmpty) {
      setState(() {
        _errorMessage = '⚠️ Vui lòng nhập số bàn';
      });
      return;
    }

    final num = int.tryParse(tableNumber);
    if (num == null || num < 1 || num > 21) {
      setState(() {
        _errorMessage = '⚠️ Số bàn phải từ 1-21';
      });
      return;
    }

    // 📍 Kiểm tra: bàn hiện tại là bàn nào?
    final menuProvider = context.read<MenuProvider>();
    final currentTableNum = menuProvider.tableNumber;
    
    // 🔄 CHỈ CLEAR nếu THAY ĐỔI bàn (không clear lần đầu)
    if (currentTableNum != 0 && currentTableNum != num) {
      print("🔄 THAY ĐỔI BÀN: $currentTableNum → $num (CLEAR)");
      final cartProvider = context.read<CartProvider>();
      final orderProvider = context.read<OrderProvider>();
      final chatProvider = context.read<ChatProvider>();
      
      cartProvider.clearCart();
      orderProvider.clearOrders();
      chatProvider.clearMessages();
    } else {
      print("📍 Bàn lần đầu hoặc cùng bàn (KHÔNG CLEAR)");
    }
    
    // Lưu số bàn vào Provider
    menuProvider.setTableNumber(num);
    print("📍 Current table: $num");

    // 📥 Load menu
    menuProvider.loadMenu();

    // Chuyển sang HomeScreen (sau khi menu load)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null, // Không có nút back mặc định
        title: Text(
          'Chọn Bàn',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '🍣',
                      style: GoogleFonts.inter(fontSize: 64),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Rtuss Sushi',
                      style: GoogleFonts.dancingScript(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Trải nghiệm ẩm thực Nhật Bản',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Chào mừng bạn!',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Vui lòng nhập số bàn của bạn\nđể bắt đầu gọi món',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Table Number Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _errorMessage != null
                              ? Colors.redAccent
                              : Colors.teal.shade200,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _tableController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade600,
                        ),
                        decoration: InputDecoration(
                          hintText: '1',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 48,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        ),
                        onSubmitted: (_) => _submitTableNumber(),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitTableNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Bắt Đầu Gọi Món',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Table Grid (21 tables)
                    Text(
                      'Số bàn có sẵn (1-21)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 7,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                      children: List.generate(21, (index) {
                        final tableNum = index + 1;
                        final isSelected =
                            _tableController.text == tableNum.toString();
                        return GestureDetector(
                          onTap: () {
                            _tableController.text = tableNum.toString();
                            setState(() => _errorMessage = null);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.teal.shade600
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.teal.shade600
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.teal
                                            .shade600
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                tableNum.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  '© 2025 Rtuss Sushi',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
