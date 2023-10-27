import 'package:flutter/material.dart';
import 'package:saveup/pages/appbar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppbarScreen(),
      ),
      body: Center(
        child: Text("Bienvenido a HomeScreen")
      ),
    );
  }
}