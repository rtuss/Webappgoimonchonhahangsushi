import 'package:flutter/material.dart';

// ⚠️ ⚠️ ⚠️ FILE CỮ - KHÔNG DÙNG! 
// Sử dụng menu_list_screen.dart thay vì file này
// File này chỉ có dữ liệu mock, không kết nối backend
// ⚠️ ⚠️ ⚠️

@Deprecated('Sử dụng MenuListScreen thay vì MenuScreen')
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = [
    "Sushi",
    "Sushi Cake",
    "Sashimi",
    "Sushi Cuộn",
    "Salad",
    "Tempura",
    "Yakimono",
    "Set"
  ];

  final Map<String, List<Map<String, dynamic>>> menuItems = {
    "Sushi": [
      {
        "name": "Sushi Cá Hồi",
        "price": 50000,
        "image":
        "https://sushiworld.com.vn/wp-content/uploads/2022/09/Artboard-19-copy-79@4x-100.jpg"
      },
      {
        "name": "Sushi Thanh Cua",
        "price": 45000,
        "image":
        "https://sushiworld.com.vn/wp-content/uploads/2022/09/Artboard-19-copy-79@4x-100.jpg"
      },
    ],
    "Sashimi": [
      {
        "name": "Sashimi Cá Ngừ",
        "price": 80000,
        "image":
        "https://sushiworld.com.vn/wp-content/uploads/2022/09/Artboard-19-copy-79@4x-100.jpg"
      },
      {
        "name": "Sashimi Bạch Tuộc",
        "price": 90000,
        "image":
        "https://sushiworld.com.vn/wp-content/uploads/2022/09/Artboard-19-copy-79@4x-100.jpg"
      },
    ],
    "Tempura": [
      {
        "name": "Tôm Tempura",
        "price": 55000,
        "image":
        "https://sushiworld.com.vn/wp-content/uploads/2022/09/Artboard-19-copy-79@4x-100.jpg"
      },
    ],
  };

  String selectedCategory = "Sushi";

  @override
  Widget build(BuildContext context) {
    final items = menuItems[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              "MENU SUSHI",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white,
                shadows: [
                  Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black45)
                ],
              ),
            ),
          ),
          centerTitle: true,
          elevation: 6,
        ),
      ),
      body: Row(
        children: [
          // Sidebar danh mục
          Container(
            width: 110,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(2, 0),
                  blurRadius: 4,
                )
              ],
            ),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      )
                    ]
                        : [],
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() => selectedCategory = category);
                    },
                    title: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Grid món ăn
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 260,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final imageUrl = item["image"] ?? ""; // tránh lỗi null
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            imageUrl.isNotEmpty
                                ? imageUrl
                                : "https://via.placeholder.com/200x150.png?text=Sushi",
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Text(
                                item["name"] ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${item["price"]} VND",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 130,
                                height: 35,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: const Icon(Icons.add_shopping_cart,
                                      size: 15, color: Colors.white),
                                  label: const Text(
                                    "Thêm giỏ hàng",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
