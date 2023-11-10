import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SuccessScreen.dart'; // Importa el archivo donde se encuentra SuccessScreen
import 'EditarTarjetaScreen.dart'; // Importa el archivo donde se encuentra EditarTarjetaScreen

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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return SuccessScreen();
          },
        ),
      );


      // Espera 4 segundos y luego cierra el diálogo
      await Future.delayed(Duration(seconds: 4));

      Navigator.of(context).pop(); // Cierra el diálogo
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
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Agregar aquí la funcionalidad para cambiar la foto
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/foto_profile.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Cambiar Foto",
                      style: TextStyle(
                        color: Color(0xFFE95D5D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTextFieldPair("Nombre", nombreController, "Apellido", apellidoController),
              _buildTextField("Correo", correoController),
              _buildTextFieldPair("Departamento", departamentoController, "Distrito", distritoController),
              _buildTextField("Dirección", direccionController),
              _buildTextField("Celular", celularController),
              _buildTextField("Contraseña", contrasenaController),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _guardarCambios();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFE95D5D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        "Guardar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EditarTarjetaScreen(); // Reemplaza con el nombre de tu nuevo screen
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(

                        primary: Color(0xFFE95D5D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        "Editar tarjeta",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFF201F34), // Color de fondo
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: Color(0xFF201F34),
            ),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            controller: controller,
            style: TextStyle(color: Colors.white), // Color del texto
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }



  Widget _buildTextFieldPair(String label1, TextEditingController controller1, String label2, TextEditingController controller2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label1),
              Container(
                margin: EdgeInsets.only(left: 20, right: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF201F34), // Color de fondo
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    color: Color(0xFF201F34),
                  ),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller1,
                  style: TextStyle(color: Colors.white), // Color del texto
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label2),
              Container(
                margin: EdgeInsets.only(right: 20, left: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF201F34), // Color de fondo
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    color: Color(0xFF201F34),
                  ),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller2,
                  style: TextStyle(color: Colors.white), // Color del texto
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

}
