import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saveup/screens/checkout_screen.dart';
import 'package:saveup/utils/dbhelper.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  dynamic account;
  List<int> productIds = [];

  final StreamController<void> _updateController = StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    setupAccounts();
  }

  @override
  void dispose() {
    _updateController.close(); // Close the StreamController when the widget is disposed
    super.dispose();
  }

  Future<void> setupAccounts() async {
    final accounts = await DbHelper().getAccounts();

    setState(() {
      account = accounts[0];
    });

    final cartProducts = await DbHelper().getCart();
    setState(() {
      productIds = cartProducts.map((cartProduct) => cartProduct.productId).toList();
    });
  }

  // Add a method to trigger real-time updates
  void triggerUpdate() async {
    await setupAccounts();
    _updateController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: StreamBuilder<void>(
        stream: _updateController.stream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Puntos: ${account?.points}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de la orden',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Envío a domicilio'),
                    Text('Departamento: ${account?.department}'),
                    Text('Distrito: ${account?.district}'),
                    Text('Dirección: ${account?.address}'),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CardTotal(),
                      ShoppingCartContent(productIds: productIds, onUpdate: triggerUpdate),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 21, 21)),
                  ),
                  onPressed: () {
                
                  },
                  child: Text('Canjear puntos', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          );
        }
      )
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

  Future<int> totalProducts() async {
    final cartProducts = await DbHelper().getCart();
    if (cartProducts.isEmpty) {
      return 0; // Devuelve 0 si no hay productos en el carrito
    }

    // Suma de los campos 'quantity' de la tabla 'cart'
    final total = cartProducts.map((cartProduct) => cartProduct.quantity).reduce((value, element) => value + element);

    return total;
  }

  Future<double> totalAmount() async {
    final cartProductIds = await DbHelper().getCart();
    if (cartProductIds.isEmpty) {
      return 0.0; // Devuelve 0.0 si no hay productos en el carrito
    }

    final cartProducts = await Future.wait(cartProductIds.map((cartProduct) async {
      final response = await http.get(Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/${cartProduct.productId}'));
      if (response.statusCode == 200) {
        final product = json.decode(response.body);
        return {'product': product, 'quantity': cartProduct.quantity};
      } else {
        throw Exception('Failed to load product');
      }
    }));

    final total = cartProducts.map((cartProduct) => cartProduct['product']['price'] * cartProduct['quantity']).reduce((value, element) => value + element);

    return total.toDouble();
  }

  FutureBuilder<double> buildTotalAmount() {
    return FutureBuilder<double>(
      future: totalAmount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Verifica si snapshot.data es nulo antes de acceder a toStringAsFixed(2)
          final totalAmount = snapshot.data;
          return Text(totalAmount != null ? totalAmount.toStringAsFixed(2) : '0.00', style: colorText);
        }
      },
    );
  }

  FutureBuilder<int> buildTotalProducts() {
    return FutureBuilder<int>(
      future: totalProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final totalProducts = snapshot.data;
          final isButtonEnabled = totalProducts != null && totalProducts > 0;

          return ElevatedButton(
            style: colorButton,
            onPressed: isButtonEnabled
                ? () async {
                    final double amount = await totalAmount();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(totalPrice: amount),
                      ),
                    );
                  }
                : null, // Deshabilita el botón si no hay productos en el carrito
            child: Text('Continuar compra', style: colorButtonText),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        color: Color(0xFF201F34),
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Productos (#):', style: colorText),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FutureBuilder<int>(
                    future: totalProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(snapshot.data.toString(), style: colorText);
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Total:', style: colorText),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: buildTotalAmount(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildTotalProducts(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingCartContent extends StatelessWidget {
  final List<int> productIds;
  final Function onUpdate;

  const ShoppingCartContent({Key? key, required this.productIds, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: productIds.map((productId) {
        return FutureBuilder(
          future: fetchProduct(productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final productData = snapshot.data as Map<String, dynamic>;
              final product = productData['product'];
              final quantity = productData['quantity'];

              return ProductCard(product: product, quantity: quantity, onUpdate: onUpdate);
            }
          },
        );
      }).toList(),
    );
  }

  Future<Map<String, dynamic>> fetchProduct(int productId) async {
    final response = await http.get(Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/$productId'));
    if (response.statusCode == 200) {
      final product = json.decode(response.body);
      final cartProduct = await DbHelper().getCartByProductId(productId);
      final quantity = cartProduct!.quantity;

      return {'product': product, 'quantity': quantity};
    } else {
      throw Exception('Failed to load product');
    }
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final Function onUpdate;

  ProductCard({Key? key, required this.product, required this.quantity, required this.onUpdate}) : super(key: key);

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
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            child: Image.network(
              product['image'],
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                product['name'],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vencimiento: ${product['expirationDate']}',
                    style: colorText,
                  ),
                  Text(
                    'S/. ${product['price'].toStringAsFixed(2)}',
                    style: colorText,
                  ),
                  Text(
                    'Unidades: $quantity',
                    style: colorText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final productId = product['id'];
                          final newStock = product['stock'] + 1;

                          // Reducir la cantidad en el carrito
                          await DbHelper().decreaseQuantityInCart(productId);

                          // Obtener la nueva cantidad después de la reducción
                          final updatedCartProduct = await DbHelper().getCartByProductId(productId);
                          final updatedQuantity = updatedCartProduct?.quantity ?? 0;

                          if (updatedQuantity <= 0) {
                            // Eliminar el producto del carrito si la cantidad llega a 0 o menos
                            await DbHelper().deleteCartItemByProductId(productId);
                          }

                          try {
                            final response = await http.put(
                              Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/$productId/stock'),
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

                          await onUpdate();
                        },
                        icon: Icon(Icons.remove, color: Colors.white,),
                      ),
                      SizedBox(width: 25),
                      IconButton(
                        onPressed: () async {
                          final productId = product['id'];
                          final newStock = product['stock'] - 1;

                          if(product['stock'] - 1 < 0) {
                            // No se puede agregar más productos
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No se puede agregar más productos'),
                              ),
                            );
                            return;
                          } else {
                            await DbHelper().increaseQuantityInCart(productId);

                            try {
                              final response = await http.put(
                                Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/$productId/stock'),
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

                          await onUpdate();
                        },
                        icon: Icon(Icons.add, color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
