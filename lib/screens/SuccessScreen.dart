/*import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
}*/

import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  Future chageScreen(BuildContext context) async {
    final accounts = await DbHelper().getAccounts();
    final account = accounts[0];

    if(account.type == "customer") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed("profile"); // Reemplaza "nuevo_screen" con la ruta real
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed("company_profile"); // Reemplaza "nuevo_screen" con la ruta real
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Agregar un retraso de 2 segundos antes de la navegación
    chageScreen(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: const Color(0xFF201F34),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Text(
                "Guardado correctamente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Image(image: AssetImage("assets/check.png")),
            ),
          ],
        ),
      ),
    );
  }
}