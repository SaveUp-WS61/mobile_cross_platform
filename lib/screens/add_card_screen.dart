import 'package:flutter/material.dart';
import 'package:saveup/screens/bot_chat_screen.dart';
import 'package:saveup/screens/history_buys_screen.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 350,
                height: 550,
                decoration: BoxDecoration(
                  color: const Color(0xFF201F34),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ListView(
                  // Usa ListView para que los elementos sean desplazables
                  padding: const EdgeInsets.all(20),
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Agrega tu tarjeta',
                          style: TextStyle(
                            color: Colors.black,
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
                            color: Colors.black,
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
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            filled: true,
                            fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80),
                              borderSide: const BorderSide(
                                color: Color(0xFFE95D5D),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  80.0), // Radio de borde cuando no está enfocado
                              borderSide: const BorderSide(
                                color: Colors
                                    .white, // Color del borde cuando no está enfocado
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 250, // Establece el ancho deseado
                              height: 50, // Establece el alto deseado
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Nombre del banco",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 250, // Establece el ancho deseado
                              height: 50, // Establece el alto deseado
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Número de tarjeta",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 250, // Establece el ancho deseado
                              height: 50, // Establece el alto deseado
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "CVV",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Button
                    ElevatedButton(
                      onPressed: () {
                        // Agrega la lógica que desees para el botón
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BotChatScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE95D5D), // Color de fondo del botón
                        minimumSize: const Size(
                            200, 40), // Ancho y alto mínimos del botón
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Alinea los elementos en el centro

                        children: <Widget>[
                          Icon(Icons.add,color: Colors.black,), // Icono a la izquierda del botón
                          SizedBox(width: 15), // Espacio entre el icono y el texto
                          Text(
                            'Añadir nueva tarjeta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // Ajusta el tamaño de la fuente
                              color: Colors.black, // Color del texto del botón
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 1, // Ancho de la línea
                      color: Color(0xFF959595), // Color de la línea
                      indent: 16, // Espacio izquierdo
                      endIndent: 16, // Espacio derecho
                    ),
                     
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                            MaterialPageRoute(builder: (context) => const HistoryBuysScreen()),
                        );
                          },
                          child: const Text(
                            '¿Eres una empresa? Da click aquí',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
}
