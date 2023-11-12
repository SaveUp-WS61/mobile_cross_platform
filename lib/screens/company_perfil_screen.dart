import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saveup/screens/company_editar_perfil.dart';
import 'package:saveup/utils/dbhelper.dart'; // Importa el archivo donde se encuentra EditarPerfil

void company_perfil_screen() {
    runApp(MyApp());
  }

  class PerfilCompania extends StatefulWidget {
    @override
    _PerfilCompaniaState createState() => _PerfilCompaniaState();
  }

class _PerfilCompaniaState extends State<PerfilCompania> {
  Map<String, dynamic> userData = {};
  String hiddenPassword = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final users = await DbHelper().getUsers();
    final response = await http.get(Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for(var company in data) {
        if(company['id'] == users[0].tableId) {
          setState(() {
            userData = company;
            hiddenPassword = '*' * userData['password'].length;
          });
          break;
        }
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Perfil de Compañia"),
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
                _buildInfoRow("RUC", userData['ruc']??'Sin nombre'),
                _buildInfoRow("Correo", userData['email']??'Sin nombre'),
                _buildInfoRow("Departamento", userData['department']??'Sin nombre'),
                _buildInfoRow("Distrito", userData['district']??'Sin nombre'),
                _buildInfoRow("Dirección", userData['address']??'Sin nombre'),
                _buildInfoRow("Celular", userData['phoneNumber']??'Sin nombre'),
                _buildInfoRow("Contraseña", hiddenPassword),
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
                    builder: (context) => EditarPerfilCompania(userData), // Pasa los datos actuales
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
        home: PerfilCompania(),
      );
    }
  }
