import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:saveup/utils/dbhelper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();

  String _imageName = '';
  XFile? _selectedImage;

  String? _nameError;
  String? _descriptionError;
  String? _priceError;
  String? _stockError;
  String? _expirationDateError;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_selectedImage == null) return;

    try {
      final String fileName = basename(_selectedImage!.path);
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      final UploadTask uploadTask =
          storageReference.putFile(File(_selectedImage!.path));

      await uploadTask.whenComplete(() async {
        // Obtener la URL de la imagen después de subirla
        final imageUrl = await storageReference.getDownloadURL();
        print('Imagen subida a Firebase: $imageUrl');

        // Envía los datos del producto, incluyendo la URL de la imagen, a la API
        await _sendProductDataToAPI(imageUrl);
      });
    } catch (error) {
      print('Error al subir la imagen: $error');
    }
  }

  Future<void> _sendProductDataToAPI(String imageUrl) async {
    try {
      final accounts = await DbHelper().getAccounts();
      final account = accounts[0];
      final response = await http.post(
        Uri.parse(
            'https://saveup-production.up.railway.app/api/saveup/v1/products'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'stock': int.parse(_stockController.text),
          'expirationDate': _expirationDateController.text,
          'image': imageUrl,
          'companyId': account.tableId, // Reemplaza con tu ID de la compañía
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Producto creado exitosamente.');
        // Puedes manejar la respuesta adicionalmente según tu necesidad.
      } else {
        print(
            'Error al crear el producto. Código de estado: ${response.statusCode}');
        // Maneja el error según tus necesidades.
      }
    } catch (error) {
      print('Error de red: $error');
      // Maneja el error de red según tus necesidades.
    }
  }

  String getImageName() {
    return _imageName;
  }

  bool _validateData() {
    bool isValid = true;

    // Validar nombre
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Por favor, ingresa el nombre del producto.';
      });
      isValid = false;
    } else {
      setState(() {
        _nameError = null;
      });
    }

    // Validar descripción
    if (_descriptionController.text.isEmpty) {
      setState(() {
        _descriptionError = 'Por favor, ingresa la descripción del producto.';
      });
      isValid = false;
    } else {
      setState(() {
        _descriptionError = null;
      });
    }

    // Validar precio
    if (_priceController.text.isEmpty) {
      setState(() {
        _priceError = 'Por favor, ingresa el precio del producto.';
      });
      isValid = false;
    } else {
      try {
        double.parse(_priceController.text);
        setState(() {
          _priceError = null;
        });
      } catch (error) {
        setState(() {
          _priceError = 'El precio debe ser un número válido.';
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
    if (_expirationDateController.text.isEmpty) {
      setState(() {
        _expirationDateError =
            'Por favor, ingresa la fecha de vencimiento del producto.';
      });
      isValid = false;
    } else {
      final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
      if (!dateRegex.hasMatch(_expirationDateController.text)) {
        setState(() {
          _expirationDateError = 'El formato de la fecha debe ser DD-MM-AAAA.';
        });
        isValid = false;
      } else {
        final List<String> dateParts =
            _expirationDateController.text.split('-');
        final int day = int.parse(dateParts[0]);
        final int month = int.parse(dateParts[1]);
        final int year = int.parse(dateParts[2]);

        final DateTime currentDate = DateTime.now();
        final DateTime inputDate = DateTime(year, month, day);

        if (inputDate.isBefore(currentDate)) {
          setState(() {
            _expirationDateError =
                'La fecha de vencimiento no puede ser menor que la fecha actual.';
          });
          isValid = false;
        } else {
          setState(() {
            _expirationDateError = null;
          });
        }
      }
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 103, 197, 200),
      ),
      body: SingleChildScrollView(
        // Envuelve el contenido en un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.file(File(_selectedImage!.path)),
                        ),
                      )
                    : Icon(
                        Icons.add_a_photo,
                        size: 120,
                      ),
              ),
              Text(getImageName()),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del producto',
                  labelStyle: const TextStyle(
                    color: Color(0xFF201F34),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF201F34),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF201F34),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _nameError,
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    _nameError = null;
                  });
                },
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción del producto',
                  labelStyle: const TextStyle(
                    color: Color(0xFF201F34),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF201F34),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF201F34),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _descriptionError,
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    _descriptionError = null;
                  });
                },
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        labelStyle: const TextStyle(
                          color: Color(0xFF201F34),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF201F34),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF201F34),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _priceError,
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _priceError = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: 'Stock',
                        labelStyle: const TextStyle(
                          color: Color(0xFF201F34),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF201F34),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF201F34),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _stockError,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {
                          _stockError = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              TextFormField(
                controller: _expirationDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de vencimiento (DD-MM-AAAA)',
                  labelStyle: const TextStyle(
                    color: Color(0xFF201F34),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF201F34),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF201F34),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _expirationDateError,
                ),
                onChanged: (value) {
                  setState(() {
                    _expirationDateError = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () async {
                    if (_validateData()) {
                      // Subir la imagen a Firebase antes de realizar otras acciones
                      await _uploadImageToFirebase();

                      // Implementar lógica de envío del formulario aquí
                      // ...

                      // Limpiar campos después de enviar el formulario
                      _nameController.clear();
                      _descriptionController.clear();
                      _priceController.clear();
                      _stockController.clear();
                      _expirationDateController.clear();

                      // Verificar si el widget está montado antes de llamar a setState
                      if (mounted) {
                        setState(() {
                          _selectedImage = null;
                        });
                      }

                      // Navegar solo si la validación y el envío de datos fueron exitosos
                      Navigator.of(context)
                          .pushReplacementNamed("company_products");
                    }
                  },
                  child: Text('Publicar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE95D5D),
                    foregroundColor: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
