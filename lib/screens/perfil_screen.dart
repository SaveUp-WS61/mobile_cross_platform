import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'editar_perfil.dart'; // Importa el archivo donde se encuentra EditarPerfil

void perfil_screen() {
    runApp(MyApp());
  }

  class PerfilComprador extends StatefulWidget {
    @override
    _PerfilCompradorState createState() => _PerfilCompradorState();
  }

class _PerfilCompradorState extends State<PerfilComprador> {
  Map<String, dynamic> userData = {};
  String hiddenPassword = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://saveup-production.up.railway.app/api/saveup/v1/customers'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)[0];
      setState(() {
        userData = data;
        hiddenPassword = '*' * userData['password'].length;
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Perfil de Comprador"),
            centerTitle: true,
            backgroundColor: const Color(0xFF67C5C8),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Navegar hacia atrás al presionar el botón de retroceso
              },
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildInfoRow("Nombre", userData['name']??'Sin nombre'),
                _buildInfoRow("Apellido", userData['lastName']??'Sin nombre'),
                _buildInfoRow("Correo", userData['email']??'Sin nombre'),
                _buildInfoRow("Departamento", userData['department']??'Sin nombre'),
                _buildInfoRow("Distrito", userData['district']??'Sin nombre'),
                _buildInfoRow("Dirección", userData['address']??'Sin nombre'),
                _buildInfoRow("Celular", userData['phoneNumber']??'Sin nombre'),
                _buildInfoRow("Contraseña", hiddenPassword),
                _buildInfoRow("Número de tarjeta", userData['cards'] != null && userData['cards'].isNotEmpty ? userData['cards'][0] : 'N/A'),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                // Navega a la vista de edición del perfil y pasa los datos actuales
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarPerfil(userData), // Pasa los datos actuales
                  ),
                ).then((data) {
                  // Esta función se ejecuta cuando se vuelve de la vista de edición
                  if (data != null) {
                    setState(() {
                      userData = data; // Actualiza los datos con los datos editados
                    });
                  }
                });

              },

              style: ElevatedButton.styleFrom(

                primary: Color(0xFFE95D5D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text("Editar Perfil"),
            ),
          ),
        ),
      );
    }

    Widget _buildInfoRow(String label, String value) {
      if (userData != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 16), // Separación horizontal
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox(); // Otra opción es devolver un widget vacío si userData es nulo
      }
    }

  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PerfilComprador(),
      );
    }
  }
