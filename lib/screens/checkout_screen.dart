import 'package:flutter/material.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final colorText = TextStyle(color: Colors.white);
  final colorLabel = TextStyle(color: Colors.grey);
  final colorButtonText = TextStyle(color: Colors.black);
  final colorButton = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 21, 21)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Card(
        color: Color(0xFF201F34),
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Departamento',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Distrito',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Número Telefónico',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Número de Tarjeta',
                  labelStyle: colorLabel,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: colorText,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: colorButton,
                  onPressed: () { Navigator.of(context).pushReplacementNamed("purchase_confirmation"); },
                  child: Text(
                    'Aceptar Compra',
                    style: colorButtonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}