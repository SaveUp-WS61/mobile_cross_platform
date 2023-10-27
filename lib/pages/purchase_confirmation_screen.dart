import 'package:flutter/material.dart';
import 'package:saveup/pages/appbar_screen.dart';

class PurchaseConfirmation extends StatelessWidget {
  const PurchaseConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppbarScreen(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: const Color(0xFF201F34),
                borderRadius: BorderRadius.circular(15.0)
              ),
              child: const Text(
                "Confirmacion de \ncompra exitosa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Image(
              image: AssetImage("assets/purchase_confirmation_image.png")
            )
          ]
        ),
      ),
    );
  }
}