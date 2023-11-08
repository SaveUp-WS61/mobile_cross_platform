import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true, // Para ocultar la contraseña
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para iniciar sesión
                final email = emailController.text;
                final password = passwordController.text;

                Navigator.of(context).pushReplacementNamed("products");
                // Agregar aquí la lógica de autenticación
              },
              child: Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("register");
              },
              child: Text('¿No tienes una cuenta? Registrate ahora'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("recover_password");
              },
              child: Text('¿Olvidó su Contraseña?'),
            ),
          ],
        ),
      ),
    );
  }
}