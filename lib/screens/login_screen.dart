import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saveup/models/account.dart';
import 'package:saveup/utils/dbhelper.dart';

Color myCustomColor = const Color.fromARGB(255, 103, 197, 200);
// Define el widget de TextFormField reutilizable
Widget buildFormTextField(TextEditingController controller, String labelText, {bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: isPassword,
    ),
  );
}
class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFormTextField(emailController, 'Correo Electrónico'),
                SizedBox(height: 16),
                buildFormTextField(passwordController, 'Contraseña', isPassword: true),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: ()  async {
                    // Lógica para iniciar sesión
                    final email = emailController.text;
                    final password = passwordController.text;
                    String type = 'default';

                    // Agregar aquí la lógica de autenticación
                    //Navigator.of(context).pushReplacementNamed("company_products");
                    final customersResponse = await http.get(Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/customers'));
                    final customersData = json.decode(customersResponse.body) as List;

                    final companiesResponse = await http.get(Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies'));
                    final companiesData = json.decode(companiesResponse.body) as List;

                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password
                      );

                      User? user = userCredential.user;

                      bool emailExists = false;

                    for (var customer in customersData) {
                      if (customer['email'] == email) {
                        emailExists = true;
                        type = 'customer';
                        // Guardar los datos del usuario en la tabla "account"
                        final account = Account(
                          // Aquí asigna los datos del usuario según la estructura de la tabla
                          0,
                          customer['id'],
                          customer['email'],
                          customer['name'],
                          customer['address'],
                          customer['department'],
                          customer['district'],
                          customer['phoneNumber'],
                          customer['password'],
                          customer['repeatPassword'],
                          customer['lastName'],
                          '',
                          customer['points'],
                          'customer'
                        );
                        await DbHelper().insertAccount(account);
                        break;
                      }
                    }

                    if (!emailExists) {
                      for (var company in companiesData) {
                        if (company['email'] == email) {
                          emailExists = true;
                          type = 'company';
                          // Guardar los datos del usuario en la tabla "account"
                          final account = Account(
                            0,
                            // Aquí asigna los datos del usuario según la estructura de la tabla
                            company['id'],
                            company['email'],
                            company['name'],
                            company['address'],
                            company['department'],
                            company['district'],
                            company['phoneNumber'],
                            company['password'],
                            company['repeatPassword'],
                            '',
                            company['ruc'],
                            0,
                            'company'
                          );
                          await DbHelper().insertAccount(account);
                          break;
                        }
                      }
                    }

                    if (emailExists) {
                      // El usuario existe, realiza la lógica de autenticación
                      if(type == 'customer') {
                        Navigator.of(context).pushReplacementNamed("products");
                      }
                      else if (type == 'company') {
                        Navigator.of(context).pushReplacementNamed("company_products");
                      }
                    }
                    } catch (e) {
                      final currentContext = context; // Captura el contexto actual

                      showDialog(
                        context: currentContext,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error de autenticación"),
                            content: Text("El usuario no existe."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(currentContext).pop(); // Usa el contexto capturado
                                },
                                child: Text("Cerrar"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: myCustomColor, // Utiliza tu color personalizado aquí
                  ),
                  child: Text('Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("recover_password");
                  },
                  child: Text('¿Olvidó su Contraseña?',
                    style: TextStyle(
                      color: Colors.black,
                    ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}