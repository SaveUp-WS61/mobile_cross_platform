import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:saveup/utils/dbhelper.dart';

class EditarTarjetaScreen extends StatefulWidget {
  @override
  _EditarTarjetaScreenState createState() => _EditarTarjetaScreenState();
}

class _EditarTarjetaScreenState extends State<EditarTarjetaScreen> {
  // Lista para almacenar las tarjetas
  List<Map<String, dynamic>> tarjetas = [];

  @override
  void initState() {
    super.initState();
    // Realiza una solicitud HTTP para obtener los datos de las tarjetas
    fetchTarjetas();
  }

  Future<void> fetchTarjetas() async {
    final accounts = await DbHelper().getAccounts();
    final account = accounts[0];
    try {
      final response = await http.get(
          Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/cards/customer/${account.tableId}'));

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, analiza los datos JSON
        final data = json.decode(response.body);
        if (data is List) {
          if (mounted) {
            // Verifica que el widget aún esté montado antes de llamar a setState
            setState(() {
              // Actualiza la lista de tarjetas
              tarjetas = List<Map<String, dynamic>>.from(data);
            });
          }
        } // Actualiza la pantalla para mostrar las tarjetas
      } else {
        // Si la solicitud falla, maneja el error
        print('Error al cargar las tarjetas');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    // Agrega cualquier limpieza necesaria aquí
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar tarjeta"),
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                decoration: BoxDecoration(
                  color: Color(0xFF201F34),
                  borderRadius: BorderRadius.circular(25.0), // Establece el radio de los bordes
                ),
                padding: EdgeInsets.all(30.0),
                child: ListView.builder(
                  itemCount: tarjetas.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      type: tarjetas[index]['type'],
                      cardNumber: tarjetas[index]['cardNumber'],
                    );
                  },
                ),
                // Si el numero de tarjetas es 0 el tamaño debe ser 0
                // Si el numero de tarjetas es 1 o mas debe ser la formula "tarjetas.length * 100 - (tarjetas.length - 1) * 16"
                height: tarjetas.length == 0
                    ? 0
                    : (tarjetas.length * 125) - ((tarjetas.length - 1) * 50),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("add_card");
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFE95D5D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Añadir Tarjeta",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String type;
  final String cardNumber;

  CardWidget({required this.type, required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              type,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(cardNumber),
          ],
        ),
      ),
    );
  }
}