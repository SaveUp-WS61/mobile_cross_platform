import 'package:flutter/material.dart';
import 'package:saveup/pages/home_screen.dart';
import 'package:saveup/pages/logout_screen.dart';
import 'package:saveup/pages/products_screen.dart';
import 'package:saveup/pages/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash",
      routes: {
        "splash": (context) => const SplashScreen(),
        "home": (context) => const HomeScreen(),
        "logout": (context) => const LogoutScreen(),
        "products":(context) => ProductsScreen(),
      },
    );
  }
}