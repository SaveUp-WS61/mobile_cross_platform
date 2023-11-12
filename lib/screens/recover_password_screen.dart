import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class RecoverPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myCustomColor,
        title: Text('Recuperar Contraseña'),
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
                ElevatedButton(
                  onPressed: () async {
                    // Validar que el input no esté vacío
                    if (emailController.text.isNotEmpty) {
                      try {
                        await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Correo electrónico de restablecimiento enviado'),
                          )
                        );

                        // Redirigir a la pantalla de login
                        Navigator.of(context).pushReplacementNamed("login");
                        
                      } on FirebaseAuthException catch (e) {
                        print(e);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message ?? 'Error al enviar el correo electrónico de restablecimiento'),
                          )
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: myCustomColor, // Utiliza tu color personalizado aquí
                  ),
                  child: Text('Enviar Nueva Contraseña'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
