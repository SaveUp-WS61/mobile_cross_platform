import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';
import 'package:saveup/widgets/bar/company_toolbar.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:http/http.dart' as http;

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

/*class CompanyProductsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CompanyToolbar(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 65),
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
                              IconButton(
                                onPressed: (){ Navigator.of(context).pushNamed("edit_publication"); },
                                icon: const Icon(Icons.edit)
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
          Positioned(
            bottom: 16,
            left: 0,
            right: 0, // Ajusta la posición vertical del botón según tus necesidades
            child: Center(
              child: Transform.scale(
                scale: 0.8,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pushNamed("add_product");
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar producto"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFFE95D5D),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

class CompanyProductsScreen extends StatefulWidget {
  const CompanyProductsScreen({super.key});

  @override
  State<CompanyProductsScreen> createState() => _CompanyProductsScreenState();
}

class _CompanyProductsScreenState extends State<CompanyProductsScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Llamada a la función para cargar los productos desde la API
    loadProducts();
  }

  Future<void> loadProducts() async {
    final accounts = await DbHelper().getAccounts();
    final account = accounts[0];

    final response = await http.get(
      Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/company/${account.tableId}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsData = jsonDecode(response.body);

      setState(() {
        // Mapear los datos de la API a objetos Product
        products = productsData.map((data) {
          return Product(
            nombre: data['name'],
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
        child: CompanyToolbar(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 65),
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
                                onPressed: (){ Navigator.of(context).pushNamed("edit_publication"); },
                                icon: const Icon(Icons.edit)
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
          Positioned(
            bottom: 16,
            left: 0,
            right: 0, // Ajusta la posición vertical del botón según tus necesidades
            child: Center(
              child: Transform.scale(
                scale: 0.8,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pushNamed("add_product");
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar producto"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFFE95D5D),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}