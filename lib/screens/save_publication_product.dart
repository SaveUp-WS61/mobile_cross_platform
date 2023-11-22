import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saveup/screens/company_products_screen.dart';
import 'package:saveup/utils/dbhelper.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';
import 'package:http/http.dart' as http;

class SavePublicationProduct extends StatelessWidget {
  final Product product;

  const SavePublicationProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: SavePublicationPage(product: product),
    );
  }
}

class SavePublicationPage extends StatefulWidget {
  final Product product;

  const SavePublicationPage({Key? key, required this.product}) : super(key: key);

  @override
  _SavePublicationPageState createState() => _SavePublicationPageState();
}

class _SavePublicationPageState extends State<SavePublicationPage> {
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _stockController;
  late TextEditingController _fechaVencimientoController;

  String? _nombreError;
  String? _descripcionError;
  String? _precioError;
  String? _stockError;
  String? _fechaVencimientoError;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores iniciales de widget.product
    _nombreController = TextEditingController(text: widget.product.nombre);
    _descripcionController = TextEditingController(text: widget.product.descripcion);
    _precioController = TextEditingController(text: widget.product.precio.toString());
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _fechaVencimientoController = TextEditingController(text: widget.product.fechaVencimiento);
  }

  bool _validateData() {
    bool isValid = true;

    // Validar nombre
    if (_nombreController.text.isEmpty) {
      setState(() {
        _nombreError = 'Por favor, ingresa el nombre del producto.';
      });
      isValid = false;
    } else {
      setState(() {
        _nombreError = null;
      });
    }

    // Validar descripción
    if (_descripcionController.text.isEmpty) {
      setState(() {
        _descripcionError = 'Por favor, ingresa la descripción del producto.';
      });
      isValid = false;
    } else {
      setState(() {
        _descripcionError = null;
      });
    }

    // Validar precio
    if (_precioController.text.isEmpty) {
      setState(() {
        _precioError = 'Por favor, ingresa el precio del producto.';
      });
      isValid = false;
    } else {
      try {
        double.parse(_precioController.text);
        setState(() {
          _precioError = null;
        });
      } catch (error) {
        setState(() {
          _precioError = 'El precio debe ser un número válido.';
        });
        isValid = false;
      }
    }

    // Validar stock
    if (_stockController.text.isEmpty) {
      setState(() {
        _stockError = 'Por favor, ingresa el stock del producto.';
      });
      isValid = false;
    } else {
      try {
        int.parse(_stockController.text);
        setState(() {
          _stockError = null;
        });
      } catch (error) {
        setState(() {
          _stockError = 'El stock debe ser un número entero válido.';
        });
        isValid = false;
      }
    }

    // Validar fecha de vencimiento
    if (_fechaVencimientoController.text.isEmpty) {
      setState(() {
        _fechaVencimientoError = 'Por favor, ingresa la fecha de vencimiento del producto.';
      });
      isValid = false;
    } else {
      final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
      if (!dateRegex.hasMatch(_fechaVencimientoController.text)) {
        setState(() {
          _fechaVencimientoError = 'El formato de la fecha debe ser DD-MM-AAAA.';
        });
        isValid = false;
      } else {
        final List<String> dateParts = _fechaVencimientoController.text.split('-');
        final int day = int.parse(dateParts[0]);
        final int month = int.parse(dateParts[1]);
        final int year = int.parse(dateParts[2]);

        final DateTime currentDate = DateTime.now();
        final DateTime inputDate = DateTime(year, month, day);

        if (inputDate.isBefore(currentDate)) {
          setState(() {
            _fechaVencimientoError = 'La fecha de vencimiento no puede ser menor que la fecha actual.';
          });
          isValid = false;
        } else {
          setState(() {
            _fechaVencimientoError = null;
          });
        }
      }
    }

    return isValid;
  }

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

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: rectWidth,
              height: rectHeight,
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
                    child: Image.network(widget.product.imagen),
                  ),
                  SizedBox(height: 10),
                  _buildEditableField("Nombre del producto", _nombreController, _nombreError),
                  _buildEditableField("Descripción del producto", _descripcionController, _descripcionError),
                  _buildEditableField("Precio", _precioController, _precioError),
                  _buildEditableField("Stock", _stockController, _stockError),
                  _buildEditableField("Fecha de vencimiento", _fechaVencimientoController, _fechaVencimientoError),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_validateData()) {
                  final accounts = await DbHelper().getAccounts();
                  final account = accounts[0];
    
                  // Lógica para editar el producto
                  final String nombre = _nombreController.text;
                  final String descripcion = _descripcionController.text;
                  final double precio = double.tryParse(_precioController.text) ?? 0.0;
                  final int stock = int.tryParse(_stockController.text) ?? 0;
                  final String fechaVencimiento = _fechaVencimientoController.text;
    
                  final Map<String, dynamic> requestBody = {
                    "name": nombre,
                    "description": descripcion,
                    "price": precio,
                    "stock": stock,
                    "expirationDate": fechaVencimiento,
                    "image": widget.product.imagen, 
                    "companyId": account.tableId,
                  };
    
                  final response = await http.put(
                    Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/products/${widget.product.id}'),
                    body: jsonEncode(requestBody),
                    headers: {"Content-Type": "application/json"},
                  );
    
                  if (response.statusCode == 200) {
                    print("Cambio correcto");
                    Navigator.of(context).pushReplacementNamed("company_products");
                  } else {
                    // Manejar el error de la solicitud
                    print('Error al editar el producto. Código de estado: ${response.statusCode}');
                    // Puedes mostrar un mensaje de error al usuario si lo deseas
                  }
                }
              },
              child: Text(
                'Guardar',
                style: TextStyle(fontSize: 20),
              ),
              style: buttonStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, String? error) {
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
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 32, 46, 66),
                errorText: error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}