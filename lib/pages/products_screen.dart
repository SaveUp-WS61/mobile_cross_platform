import 'package:flutter/material.dart';
import 'package:saveup/pages/appbar_screen.dart';
import 'package:saveup/pages/navbar_screen.dart';

class Product {
  final String nombre;
  final String fechaVencimiento;
  final double precio;
  final int stock;
  final String imagen;

  Product({
    required this.nombre,
    required this.fechaVencimiento,
    required this.precio,
    required this.stock,
    required this.imagen,
  });
}

class ProductsScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
    Product(
      nombre: "Producto 1",
      fechaVencimiento: "2023, 12, 31",
      precio: 19.99,
      stock: 10,
      imagen: "assets/random_product.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarScreen(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppbarScreen(),
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Wrap(
                children: products.map((product) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 56) / 2,
                    margin: const EdgeInsets.all(10.0),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              product.imagen,
                              height: 100.0,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              product.nombre,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Fecha de vencimiento:\n${product.fechaVencimiento}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Precio: S/.${product.precio.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Stock: ${product.stock}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
    );
  }
}