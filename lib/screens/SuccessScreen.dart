import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Perfil de Comprador"),
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              decoration: BoxDecoration(
                color: Color(0xFF201F34),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  color: Color(0xFF201F34),
                ),
              ),
              padding: EdgeInsets.all(25),
              child: const Text(
                "Guardado correctamente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Image.asset(
              'assets/check.png',
              width: 180,
              height: 180,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
