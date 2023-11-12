import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Column(
                children: <Widget>[
                  const Text(
                    "Desea cerrar sesión",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        color: const Color(0xFFE95D5D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Ajusta el radio aquí
                        ),
                        child: const Text(
                          "SI",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        onPressed: () async {
                          // Eliminar todos los datos de la tabla "account"
                          final dbHelper = DbHelper();
                          await dbHelper.deleteAllAccounts();

                          // Redirigir a la pantalla de login
                          Navigator.of(context).pushReplacementNamed("login");
                        },
                      ),
                      const SizedBox(width: 30),
                      MaterialButton(
                        color: const Color(0xFFE95D5D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Ajusta el radio aquí
                        ),
                        child: const Text(
                          "NO",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        onPressed: () { Navigator.of(context).pushReplacementNamed("products"); },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
