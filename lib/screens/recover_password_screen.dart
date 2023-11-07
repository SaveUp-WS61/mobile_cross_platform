import 'package:flutter/material.dart';

class RecoverPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

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
            ElevatedButton(
              onPressed: () {
                // Lógica para recuperar contraseña
                // Agregar aquí la lógica para la recuperación de contraseña
              },
              child: Text('Enviar Nueva Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}