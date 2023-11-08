import 'package:flutter/material.dart';
Color myCustomColor = Color(0xFFE95D5D);
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
      appBar: AppBar(
        backgroundColor: myCustomColor,
        title: Text('Inicio de Sesión'),
      ),
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
                  onPressed: () {
                    // Lógica para iniciar sesión
                    final email = emailController.text;
                    final password = passwordController.text;
                    // Agregar aquí la lógica de autenticación
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
                    Navigator.pushNamed(context, '/forgot_password');
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