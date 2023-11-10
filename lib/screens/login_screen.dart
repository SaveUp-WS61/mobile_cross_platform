import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saveup/models/user.dart';
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
          image: AssetImage('assets/background.png'),
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

                    bool emailExists = false;

                    for (var customer in customersData) {
                      if (customer['email'] == email && customer['password'] == password) {
                        emailExists = true;
                        type = 'customer';
                        // Guardar los datos del usuario en la tabla "user"
                        final user = User(
                          // Aquí asigna los datos del usuario según la estructura de la tabla
                          customer['id'],
                          'customer'
                        );
                        await DbHelper().insertUser(user);
                        break;
                      }
                    }

                    if (!emailExists) {
                      for (var company in companiesData) {
                        if (company['email'] == email && company['password'] == password) {
                          emailExists = true;
                          type = 'company';
                          // Guardar los datos del usuario en la tabla "user"
                          final user = User(
                            // Aquí asigna los datos del usuario según la estructura de la tabla
                            company['id'],
                            'company'
                          );
                          await DbHelper().insertUser(user);
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
                    } else {
                      // El usuario no existe, muestra un mensaje de error en una alerta
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