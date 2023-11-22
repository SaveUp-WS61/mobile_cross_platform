import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatelessWidget {
  final double totalPrice;

  const CheckoutScreen({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: CheckoutPage(totalPrice: totalPrice),
    );
  }
}

class CartItem {
  int productId;
  int orderId;
  int quantity;

  CartItem({
    required this.productId,
    required this.orderId,
    required this.quantity,
  });
}

class CheckoutPage extends StatelessWidget {
  final double totalPrice;

  final colorText = TextStyle(color: Colors.white);
  final colorLabel = TextStyle(color: Colors.grey);
  final colorButtonText = TextStyle(color: Colors.black);
  final colorButton = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 21, 21)),
  );

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final departmentController = TextEditingController();
  final districtController = TextEditingController();
  final phoneController = TextEditingController();
  final cardNumberController = TextEditingController();

  CheckoutPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Card(
              color: Color(0xFF201F34),
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
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
                        controller: lastNameController,
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
                        controller: addressController,
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
                        controller: departmentController,
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
                        controller: districtController,
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
                        controller: phoneController,
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
                        controller: cardNumberController,
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
                          onPressed: () async {
                            try {
                              // Obtener datos de los controladores
                              String customerName = nameController.text;
                              String customerLastName = lastNameController.text;
                              String phoneNumber = phoneController.text;
                              String cardNumber = cardNumberController.text;
                              String payAddress = addressController.text;
                              String payDepartment = departmentController.text;
                              String payDistrict = districtController.text;
                              double amount = totalPrice;

                              // Obtener el usuario desde la persistencia
                              final accounts = await DbHelper().getAccounts();
                              final account = accounts[0];

                              int newPoints = account.points + (totalPrice / 4).round();

                              // Validar que los campos coincidan con los datos del usuario
                              if (customerName != account.name ||
                                  customerLastName != account.lastName ||
                                  phoneNumber != account.phoneNumber) {
                                // Campos incorrectos, mostrar mensaje o realizar alguna acción
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Los datos del usuario no coinciden'),
                                  ),
                                );
                                return;
                              }

                              // Hacer la solicitud HTTP para obtener las tarjetas del usuario
                              final responseCards = await http.get(
                                Uri.parse('http://saveup-production.up.railway.app/api/saveup/v1/cards/customer/${account.id}'),
                              );

                              if (responseCards.statusCode == 200) {
                                final List<dynamic> userCards = json.decode(responseCards.body);

                                // Verificar que el número de tarjeta ingresado exista en los datos proporcionados
                                if (!userCards.any((card) => card['cardNumber'] == cardNumber)) {
                                  // Número de tarjeta no encontrado, mostrar mensaje o realizar alguna acción
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('El número de tarjeta no pertenece al usuario'),
                                    ),
                                  );
                                  return;
                                }
                              } else {
                                // Error al obtener las tarjetas del usuario
                                print('Error al obtener las tarjetas del usuario. Código de estado: ${responseCards.statusCode}');
                                return;
                              }

                              // Crear el pago
                              final responsePay = await http.post(
                                Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/pays'),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  "customerName": customerName,
                                  "customerLastName": customerLastName,
                                  "phoneNumber": phoneNumber,
                                  "cardNumber": cardNumber,
                                  "payAddress": payAddress,
                                  "payDepartment": payDepartment,
                                  "payDistrict": payDistrict,
                                  "amount": amount,
                                }),
                              );

                              if (responsePay.statusCode == 200 || responsePay.statusCode == 201) {
                                // Pago creado exitosamente
                                final Map<String, dynamic> pay = json.decode(responsePay.body);

                                // Crear el pedido
                                final responseOrder = await http.post(
                                  Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/orders'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({
                                    "payId": pay['id'],
                                  }),
                                );

                                if (responseOrder.statusCode == 200 || responseOrder.statusCode == 201) {
                                  // Pedido creado exitosamente
                                  final Map<String, dynamic> order = json.decode(responseOrder.body);

                                  // Obtener elementos del carrito desde la persistencia de datos
                                  final cartItems = await DbHelper().getCart();

                                  // Crear elementos del carrito
                                  for (var cartItem in cartItems) {
                                    final responseCart = await http.post(
                                      Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/carts'),
                                      headers: {'Content-Type': 'application/json'},
                                      body: jsonEncode({
                                        "productId": cartItem.productId,
                                        "orderId": order['id'],
                                        "quantity": cartItem.quantity,
                                      }),
                                    );

                                    if (responseCart.statusCode != 200 && responseCart.statusCode != 201) {
                                      // Error al crear el elemento del carrito
                                      throw Exception('Error al crear el elemento del carrito');
                                    }
                                  }

                                  // Eliminar elementos del carrito de la persistencia de datos
                                  await DbHelper().deleteAllCartItems();

                                  // Actualizar puntos del cliente
                                  final responseUpdatePoints = await http.put(
                                    Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/customers/${account.tableId}/points'),
                                    headers: {'Content-Type': 'application/json'},
                                    body: jsonEncode(newPoints),
                                  );

                                  if (responseUpdatePoints.statusCode != 200 && responseUpdatePoints.statusCode != 201) {
                                    // Error al actualizar puntos del cliente
                                    throw Exception('Error al actualizar puntos del cliente');
                                  }

                                  // Actualizar puntos en la persistencia del account
                                  account.points = newPoints; // Reemplaza 'newPoints' con la cantidad adecuada de puntos
                                  await DbHelper().updateAccount(account.id, account);

                                  // Navegación a la pantalla de confirmación de compra
                                  Navigator.of(context).pushReplacementNamed("purchase_confirmation");

                                  // Cerrar todas las pantallas excepto la actual
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                } else {
                                  // Error al crear el pedido
                                  throw Exception('Error al crear el pedido');
                                }
                              } else {
                                // Error al crear el pago
                                throw Exception('Error al crear el pago');
                              }
                            } catch (error) {
                              // Manejo de errores, por ejemplo, mostrar un mensaje al usuario
                              print('Error: $error');
                            }
                          },
                          child: Text(
                            'Aceptar Compra',
                            style: colorButtonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
