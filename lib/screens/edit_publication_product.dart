import 'package:flutter/material.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';

class EditPublicationProduct extends StatelessWidget {
  const EditPublicationProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: EditPublicationPage(),
    );
  }
}

class EditPublicationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final rectWidth = screenSize.width * 0.9;
    final rectHeight = screenSize.height * 0.75;

    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: Size(120, 50),
      primary: Color.fromARGB(255, 240, 98, 98),
      onPrimary: Colors.black,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: rectWidth, // Ancho
            height: rectHeight, // Alto
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 4.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 140.0,
                  width: 120.0,
                  child: Image.asset('assets/coca_cola.jpg'),
                ),
                SizedBox(height: 10),
                _buildProductDetail("Nombre del producto", "Coca Cola"),
                _buildProductDetail(
                    "Descripción del producto", "Bebida gasificada"),
                _buildProductDetail("Precio", "S/ 13.00"),
                _buildProductDetail("Stock", "150"),
                _buildProductDetail("Fecha de vencimiento", "17-02-2024"),
              ],
            ),
          ),
          SizedBox(height: 10), // Espacio
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Lógica
                },
                child: Text(
                  'Editar',
                  style: TextStyle(fontSize: 20),
                ),
                style: buttonStyle,
              ),
              SizedBox(width: 40), // Espacio
              ElevatedButton(
                onPressed: () {
                  // Lógica
                },
                child: Text(
                  'Eliminar',
                  style: TextStyle(fontSize: 20),
                ),
                style: buttonStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ElevatedButton(
              onPressed: () {
                // Lógica
              },
              style: ElevatedButton.styleFrom().copyWith(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 32, 46, 66)),
              ),
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
