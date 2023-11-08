import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response = await http.get(
        Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/cards'));

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, analiza los datos JSON
      final data = json.decode(response.body);
      if (data is List) {
        tarjetas = List<Map<String, dynamic>>.from(data);
      }
      setState(() {}); // Actualiza la pantalla para mostrar las tarjetas
    } else {
      // Si la solicitud falla, maneja el error
      print('Error al cargar las tarjetas');
    }
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
      body: Center(
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

          // Establece la altura del Container según el número de tarjetas
          height: tarjetas.length * 105.0, // Puedes ajustar esto según sea necesario
        ),
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