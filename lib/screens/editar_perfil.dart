import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'perfil_screen.dart';

class EditarPerfil extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditarPerfil(this.userData);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {

  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController correoController;
  late TextEditingController departamentoController;
  late TextEditingController distritoController;
  late TextEditingController direccionController;
  late TextEditingController celularController;
  late TextEditingController contrasenaController;



  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales
    nombreController = TextEditingController(text: widget.userData['name']);
    apellidoController = TextEditingController(text: widget.userData['lastName']);
    correoController = TextEditingController(text: widget.userData['email']);
    departamentoController = TextEditingController(text: widget.userData['department']);
    distritoController = TextEditingController(text: widget.userData['district']);
    direccionController = TextEditingController(text: widget.userData['address']);
    celularController = TextEditingController(text: widget.userData['phoneNumber']);
    contrasenaController = TextEditingController(text: widget.userData['password']);
  }

  Future<void> _guardarCambios() async {
    final response = await http.put(
      Uri.parse(
          'https://saveup-production.up.railway.app/api/saveup/v1/customers/1'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': nombreController.text,
        'lastName': apellidoController.text,
        'email': correoController.text,
        'department': departamentoController.text,
        'district': distritoController.text,
        'address': direccionController.text,
        'phoneNumber': celularController.text,
        'password': contrasenaController.text,
        'repeatPassword': contrasenaController.text,
        // Agrega la confirmación de contraseña
      }),
    );

    if (response.statusCode == 200) {
      // Los datos se han actualizado correctamente

      // Muestra el diálogo de "Guardado con éxito"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Guardado con éxito"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text("Los cambios se guardaron exitosamente."),
              ],
            ),
          );
        },
      );

      // Espera 4 segundos y luego cierra el diálogo
      await Future.delayed(Duration(seconds: 2));

      Navigator.of(context).pop(); // Cierra el diálogo
      Navigator.of(context).pop();
    } else {
      // Manejar errores aquí
      final errorMessage = response.body;
      print("Error al actualizar los datos: $errorMessage");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
      ),
      body: SingleChildScrollView( // Envuelve el contenido con un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField("Nombre", nombreController),
              _buildTextField("Apellido", apellidoController),
              _buildTextField("Correo", correoController),
              _buildTextField("Departamento", departamentoController),
              _buildTextField("Distrito", distritoController),
              _buildTextField("Dirección", direccionController),
              _buildTextField("Celular", celularController),
              _buildTextField("Contraseña", contrasenaController),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _guardarCambios();
                },
                child: Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(controller: controller),
        SizedBox(height: 16),
      ],
    );
  }
}
