import 'package:flutter/material.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Puntos: 100',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de la orden',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Envío a domicilio'),
                  Text('Departamento: Lima'),
                  Text('Distrito: San Miguel'),
                  Text('Dirección: Av. Universitaria 9960'),
                ],
              ),
            ),
            CardTotal(),
            ShoppingCartContent(),
          ],
        ),
      ),
    );
  }
}

class CardTotal extends StatelessWidget {
  final colorText = TextStyle(color: Colors.white);
  final colorButtonText = TextStyle(color: Colors.black);
  final colorButton = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 21, 21)),
  );

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        color: Color(0xFF201F34),
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('Productos (#):', style: colorText),
              subtitle: Text('S/ 700', style: colorText),
            ),
            ListTile(
              title: Text('Total:', style: colorText),
              subtitle: Text('S/ 100.00', style: colorText),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                style: colorButton,
                onPressed: () { Navigator.of(context).pushNamed("checkout"); },
                child: Text('Continuar compra', style: colorButtonText),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                style: colorButton,
                onPressed: () {},
                child: Text('Eliminar orden', style: colorButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingCartContent extends StatelessWidget {
  const ShoppingCartContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductCard();
  }
}

class ProductCard extends StatelessWidget {
  final String productName = 'Coca Cola';
  final String productImage = 'assets/coca_cola.jpg';
  final String productPrice = 'S/ 100.00';
  final String productExpiration = 'Vencimiento: 01/01/2022';
  final String productStock = 'Stock: 100';
  final String productUnit = 'Unidad: 1';

  final colorText = TextStyle(color: Colors.white);
  final colorButtonText = TextStyle(color: Colors.black);
  final colorButton = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 21, 21)),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF201F34),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              height: 150.0,
              width: 70.0,
              child: Image.asset(productImage),
            ),
            title: Text(
              productName,
              style: colorText,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productExpiration,
                  style: colorText,
                ),
                Text(
                  productPrice,
                  style: colorText,
                ),
                Text(
                  productStock,
                  style: colorText,
                ),
                Text(
                  productUnit,
                  style: colorText,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: colorButton,
              onPressed: () {},
              child: Text(
                'Canjear puntos',
                style: colorButtonText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}