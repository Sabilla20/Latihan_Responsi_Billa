import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/cart_controller.dart';
import 'controllers/location_controller.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(CartController.boxName);

  await NotificationService.init();

  // Controller keranjang dibuat sekali & dipakai di semua halaman.
  Get.put(CartController(), permanent: true);
  Get.put(LocationController(), permanent: true);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(ShopediaApp(isLoggedIn: isLoggedIn));
}

class ShopediaApp extends StatelessWidget {
  final bool isLoggedIn;
  const ShopediaApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    return MaterialApp(
      title: 'Shopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green, primary: green),
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF1F8E9),
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.black87,
        ),
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
