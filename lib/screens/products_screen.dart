import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String nombre;
  final String descripcion;
  final String fechaVencimiento;
  final double precio;
  final int stock;
  final String imagen;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaVencimiento,
    required this.precio,
    required this.stock,
    required this.imagen,
  });
}

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Llamada a la función para cargar los productos desde la API
    loadProducts();
  }

  Future<void> loadProducts() async {
    final response = await http.get(
      Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsData = jsonDecode(response.body);

      setState(() {
        // Mapear los datos de la API a objetos Product
        products = productsData.map((data) {
          return Product(
            id: data['id'],
            nombre: data['name'],
            descripcion: data['description'],
            fechaVencimiento: data['expirationDate'],
            precio: data['price'].toDouble(),
            stock: data['stock'],
            imagen: data['image'],
          );
        }).toList();
      });
    } else {
      // Manejar el error de la solicitud
      print('Error al cargar productos. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
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
                          Image.network(
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
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_shopping_cart),
                          )
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