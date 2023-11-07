// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: 'Departamento'),
              ),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'Distrito'),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Número de Teléfono'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true, // Para ocultar la contraseña
              ),
              TextField(
                controller: repeatPasswordController,
                decoration: const InputDecoration(labelText: 'Repetir Contraseña'),
                obscureText: true, // Para ocultar la contraseña
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para el registro
                  final email = emailController.text;
                  final name = nameController.text;
                  final lastName = lastNameController.text;
                  final address = addressController.text;
                  final department = departmentController.text;
                  final district = districtController.text;
                  final number = numberController.text;
                  final password = passwordController.text;
                  final repeatPassword = repeatPasswordController.text;
                  // Agregar aquí la lógica de registro
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}