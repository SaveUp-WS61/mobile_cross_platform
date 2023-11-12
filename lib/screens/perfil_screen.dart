import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';
import 'editar_perfil.dart'; // Importa el archivo donde se encuentra EditarPerfil


class PerfilComprador extends StatefulWidget {
  @override
  _PerfilCompradorState createState() => _PerfilCompradorState();
}

class _PerfilCompradorState extends State<PerfilComprador> {
  Map<String, dynamic> accountData = {};
  String hiddenPassword = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final account = await DbHelper().getAccounts();
    setState(() {
      accountData = account[0].toMap();
      hiddenPassword = '*' * accountData['password'].length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildInfoRow("Nombre", accountData['name']??'Sin nombre'),
            _buildInfoRow("Apellido", accountData['lastName']??'Sin nombre'),
            _buildInfoRow("Correo", accountData['email']??'Sin nombre'),
            _buildInfoRow("Departamento", accountData['department']??'Sin nombre'),
            _buildInfoRow("Distrito", accountData['district']??'Sin nombre'),
            _buildInfoRow("Dirección", accountData['address']??'Sin nombre'),
            _buildInfoRow("Celular", accountData['phoneNumber']??'Sin nombre'),
            _buildInfoRow("Contraseña", hiddenPassword)
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
                builder: (context) => EditarPerfil(accountData), // Pasa los datos actuales
              ),
            ).then((data) {
              // Esta función se ejecuta cuando se vuelve de la vista de edición
              if (data != null) {
                setState(() {
                  accountData = data; // Actualiza los datos con los datos editados
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (accountData != null) {
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
      return SizedBox();
    }
  }
}