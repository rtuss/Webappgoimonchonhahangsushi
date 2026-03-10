import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🧩 Providers
import 'providers/menu_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/chat_provider.dart';

// 🧭 Navigation
import 'navigation/bottom_nav_bar.dart';
import 'screens/home/table_number_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()), // ⭐⭐ BẮT BUỘC
        ChangeNotifierProvider(create: (_) => ChatProvider()), // 💬 Chat messages
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sushi Customer',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFF8F8FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.teal,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),
        home: const TableNumberScreen(),
        routes: {
          '/table': (_) => const TableNumberScreen(),
          '/home': (_) => const BottomNavBar(),
        },
      ),
    );
  }
}
