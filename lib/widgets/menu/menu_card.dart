import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/menu_model.dart';
import '../../providers/cart_provider.dart';

class MenuCard extends StatelessWidget {
  final MonAnModel item;
  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat('#,###', 'vi_VN');
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== ẢNH + GIẢM GIÁ ======
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      item.hinhAnh,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: Color(0xFFEFEFEF)),
                    ),
                  ),
                ),
                if (item.giamGia > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_offer,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '-${item.giamGia.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // ====== NỘI DUNG - LAYOUT FIXED ======
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ====== TÊN MÓN (FIXED HEIGHT) ======
                    SizedBox(
                      height: 20,
                      child: Text(
                        item.tenMon,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),

                    // ====== TRẠNG THÁI ======
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.conPhucVu
                            ? const Color(0xFFE6F6EA)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: item.conPhucVu
                              ? Colors.green
                              : Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        item.conPhucVu ? 'Còn' : 'Hết',
                        style: TextStyle(
                          color: item.conPhucVu
                              ? Colors.green[700]
                              : Colors.grey[700],
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // ====== MÔ TẢ (FIXED HEIGHT) ======
                    SizedBox(
                      height: 18,
                      child: Text(
                        item.moTa,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                          height: 1.8,
                        ),
                      ),
                    ),

                    // ====== GIÁ + ĐÁNH GIÁ (FIXED HEIGHT) ======
                    SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          if (item.giamGia > 0) ...[
                            Text(
                              '${formatCurrency.format(item.gia)}đ',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${formatCurrency.format(item.giaSauGiam)}đ',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ] else
                            Text(
                              '${formatCurrency.format(item.gia)}đ',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          const Spacer(),
                          const Icon(Icons.star,
                              color: Colors.amber, size: 13),
                          const SizedBox(width: 2),
                          Text(
                            item.danhGia.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ====== NÚT THÊM VÀO GIỎ ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: SizedBox(
                width: double.infinity,
                height: 34,
                child: ElevatedButton.icon(
                  onPressed: item.conPhucVu
                      ? () {
                    try {
                      cartProvider.themMon(item);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              ' ${item.tenMon} đã được thêm vào giỏ hàng!'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                          backgroundColor: Colors.green[700],
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Lỗi: $e'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart, size: 15),
                  label: const Text(
                    'Thêm giỏ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.conPhucVu 
                        ? Colors.orangeAccent 
                        : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    disabledBackgroundColor: Colors.grey[300],
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
