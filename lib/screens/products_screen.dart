import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saveup/models/cart.dart';
import 'package:saveup/utils/dbhelper.dart';
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
  final StreamController<List<Product>> _productsController = StreamController<List<Product>>();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final response = await http.get(
      Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsData = jsonDecode(response.body);

      setState(() {
        products = productsData
            .where((data) => data['stock'] != 0)
            .map((data) {
              return Product(
                id: data['id'],
                nombre: data['name'],
                descripcion: data['description'],
                fechaVencimiento: data['expirationDate'],
                precio: data['price'].toDouble(),
                stock: data['stock'],
                imagen: data['image'],
              );
            })
            .toList();
      });

      _productsController.add(products);
    } else {
      print('Error al cargar productos. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> addToCart(Product product) async {
    final productsCart = await DbHelper().getCart();

    if (productsCart.isEmpty) {
      Cart cart = Cart(0, product.id, 1);
      await DbHelper().insertProductToCart(cart);
    } else {
      if (productsCart.any((cart) => cart.productId == product.id)) {
        await DbHelper().increaseQuantityInCart(product.id);
      } else {
        Cart cart = Cart(0, product.id, 1);
        await DbHelper().insertProductToCart(cart);
      }
    }

    await updateStock(product);

    // Actualizar la lista de productos después de la actualización del stock
    loadProducts();
  }

  Future<void> updateStock(Product product) async {
    final apiUrl = 'https://saveup-production.up.railway.app/api/saveup/v1/products/${product.id}/stock';
    final newStock = product.stock - 1;

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newStock),
      );

      if (response.statusCode == 200) {
        print('Stock actualizado');
      } else {
        print("Hay un error en el servidor. Código de estado: ${response.statusCode}");
      }
    } catch (error) {
      print('Error al actualizar el stock: $error');
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
      body: StreamBuilder<List<Product>>(
        stream: _productsController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Wrap(
                    children: snapshot.data!.map((product) {
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
                                  onPressed: () async {
                                    await addToCart(product);
                                    final productsOfCart = await DbHelper().getCart();

                                    for (var cart in productsOfCart) {
                                      print('Cart ID: ${cart.id}, Product ID: ${cart.productId}, Quantity: ${cart.quantity}');
                                    }
                                  },
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
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 181, 178, 178),));
          }
        },
      ),
    );
  }
}