import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

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
  final TextEditingController _expirationDateController = TextEditingController();

  String _imageName = '';
  XFile? _selectedImage;

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
      final UploadTask uploadTask = storageReference.putFile(File(_selectedImage!.path));

      await uploadTask.whenComplete(() async {
        // Obtener la URL de la imagen después de subirla
        final imageUrl = await storageReference.getDownloadURL();
        print('Imagen subida a Firebase: $imageUrl');
      });
    } catch (error) {
      print('Error al subir la imagen: $error');
    }
  }

  String getImageName() {
    return _imageName;
  }

  void onSubmit() async {
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
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 103, 197, 200),
      ),
      body: SingleChildScrollView( // Envuelve el contenido en un SingleChildScrollView
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
                ),
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
                ),
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
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
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
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              TextFormField(
                controller: _expirationDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de vencimiento (AAAA-MM-DD)',
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
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onSubmit,
                child: Text('Publicar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE95D5D),
                  foregroundColor: Colors.black,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}