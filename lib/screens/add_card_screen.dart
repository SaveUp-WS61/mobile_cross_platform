import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saveup/utils/dbhelper.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
      ),
      body: _CardView(),
    );
  }
}

class _CardView extends StatefulWidget {
  @override
  State<_CardView> createState() => _CardViewState();
}

class _CardViewState extends State<_CardView> {
  List<bool> isSelected = [false, false];
  final _formKey = GlobalKey<FormState>();

  // Controladores para los TextFormField
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // FocusNodes para los TextFormField
  final FocusNode _cardNameFocus = FocusNode();
  final FocusNode _cardNumberFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 350,
                height: 650,
                decoration: BoxDecoration(
                  color: const Color(0xFF201F34),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Agrega tu tarjeta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Paga tus compras sin problemas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ToggleButtons(
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              isSelected[buttonIndex] = buttonIndex == index;
                            }
                          });
                        },
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: isSelected[0]
                                  ? const Color(0xFFE95D5D)
                                  : null,
                              child: Image.asset(
                                'assets/mastercard.png',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: isSelected[1]
                                  ? const Color(0xFFE95D5D)
                                  : null,
                              child: Image.asset(
                                'assets/visa.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Theme(
                        data: ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: Colors.teal,
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            InputWithTitle(
                              title: "Nombre del banco",
                              controller: _cardNameController,
                              focusNode: _cardNameFocus,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese el nombre del banco';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            InputWithTitle(
                              title: "Número de tarjeta",
                              controller: _cardNumberController,
                              focusNode: _cardNumberFocus,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese el número de tarjeta';
                                } else if (int.tryParse(value) == null) {
                                  return 'El número de tarjeta debe ser numérico';
                                } else if (value.length != 16) {
                                  return 'El número de tarjeta debe tener 16 dígitos';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            InputWithTitle(
                              title: "CVV",
                              controller: _cvvController,
                              focusNode: _cvvFocus,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese el CVV';
                                } else if (int.tryParse(value) == null) {
                                  return 'El CVV debe ser numérico';
                                } else if (value.length != 3) {
                                  return 'El CVV debe tener 3 dígitos';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String cardName = _cardNameController.text;
                          String cardNumber = _cardNumberController.text;
                          String cvv = _cvvController.text;
                          String? cardType;
      if (isSelected[0]) {
        cardType = 'Mastercard';
      } else if (isSelected[1]) {
        cardType = 'Visa';
      } else {
        // Ningún tipo de tarjeta seleccionado
        // Puedes manejar esto según tus necesidades
        print('Por favor, selecciona un tipo de tarjeta.');
        return;
      }
      
      final accounts = await DbHelper().getAccounts();
                          int customerId = accounts[0].tableId;

                          // Verificar si la tarjeta ya existe
                          if (await doesCardExist(cardNumber)) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error'),
                                content: Text('Ya existe una tarjeta con este número.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Continuar con la lógica para agregar la tarjeta
                            Map<String, dynamic> cardData = {
                              "cardName": cardName,
                              "cardNumber": cardNumber,
                              "cvv": cvv,
                              "type": cardType,
                              "customerId": customerId,
                            };

                            try {
                              final response = await http.post(
                                Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/cards'),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode(cardData),
                              );

                              if (response.statusCode == 200 || response.statusCode == 201) {
                                print('Tarjeta añadida correctamente');
                                Navigator.of(context).pushReplacementNamed("cards");
                              } else {
                                print('Error al añadir la tarjeta. Código de estado: ${response.statusCode}');
                                print('Cuerpo de la respuesta: ${response.body}');
                              }
                            } catch (error) {
                              print('Error en la solicitud HTTP: $error');
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE95D5D),
                        minimumSize: const Size(200, 40),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Añadir nueva tarjeta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFF959595),
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para verificar la existencia de la tarjeta
  Future<bool> doesCardExist(String cardNumber) async {
    try {
      final response = await http.get(
        Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/cards'),
      );

      if (response.statusCode == 200) {
        bool exist = false;
        // Si la solicitud es exitosa, analiza los datos JSON
        final data = json.decode(response.body);
        if (data is List) {
          // Verifica si la tarjeta ya existe
          for (var card in data) {
            if (card['cardNumber'] == cardNumber) {
              exist = true;
            }
          }
        }

        return exist;
      } else {
        // Si la solicitud falla, maneja el error
        throw Exception('Error al cargar las tarjetas');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
      return false;
    }
  }
}

class InputWithTitle extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;

  const InputWithTitle({
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: const BorderSide(
                color: Color(0xFFE95D5D),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}