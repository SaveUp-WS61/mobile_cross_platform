import 'package:flutter/material.dart';

class EditarTarjetaScreen extends StatelessWidget {
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
            Navigator.of(context).pop(); // Navegar hacia atrás al presionar el botón de retroceso
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí puedes agregar los elementos para editar la tarjeta
          ],
        ),
      ),
    );
  }
}
