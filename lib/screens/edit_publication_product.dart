import 'package:flutter/material.dart';
import 'package:saveup/screens/company_products_screen.dart';
import 'package:saveup/screens/save_publication_product.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class EditPublicationProduct extends StatelessWidget {
  final Product product;

  const EditPublicationProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: EditPublicationPage(product: product),
    );
  }
}

class EditPublicationPage extends StatelessWidget {
  final Product product;

  const EditPublicationPage({Key? key, required this.product}) : super(key: key);

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
                  child: Image.network(product.imagen),
                ),
                SizedBox(height: 10),
                _buildProductDetail("Nombre del producto", product.nombre),
                _buildProductDetail(
                    "Descripción del producto", product.descripcion),
                _buildProductDetail("Precio", "S/. ${product.precio.toStringAsFixed(2)}"),
                _buildProductDetail("Stock", product.stock.toString()),
                _buildProductDetail("Fecha de vencimiento", product.fechaVencimiento),
              ],
            ),
          ),
          SizedBox(height: 10), // Espacio
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SavePublicationProduct(product: product),
                    ),
                  );
                },
                child: Text(
                  'Editar',
                  style: TextStyle(fontSize: 20),
                ),
                style: buttonStyle,
              ),
              SizedBox(width: 40), // Espacio
              ElevatedButton(
                onPressed: () async {
                  // Lógica para eliminar el producto y su imagen
                  final storageRef = FirebaseStorage.instance.refFromURL(product.imagen);
                  try {
                    // Eliminar la imagen de Firebase Storage
                    await storageRef.delete();
                  } catch (e) {
                    print('Error al eliminar la imagen de Firebase Storage: $e');
                  }

                  // Ahora, elimina el producto de la API
                  final response = await http.delete(
                    Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/${product.id}'),
                  );

                  if (response.statusCode == 200) {
                    // Producto y su imagen eliminados exitosamente
                    Navigator.of(context).pushReplacementNamed("deleted_post");
                  } else {
                    // Manejar el error de la solicitud
                    print('Error al eliminar el producto. Código de estado: ${response.statusCode}');
                    // Puedes mostrar un mensaje de error al usuario si lo deseas
                  }
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
