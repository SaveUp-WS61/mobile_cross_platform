import 'package:flutter/material.dart';
import 'package:saveup/domain/entities/message.dart';

class ChatProvide extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  ChatProvide() {
    // Agregamos el mensaje inicial del bot al constructor
    addBotMessage('Hola, soy el bot de SaveUp.\n'
      'Escribe la palabra "ayuda"\n'
      'si necesitas comunicarte\n'
      'con nosotros.'
    );
  }

  List<Message> messageList = [];
  bool waitingForUserInput = false;
  bool askingToContinue = false;

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    final userInput = text.trim().toLowerCase(); // Elimina los espacios en blanco y convierte a minúsculas

    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);

    if (userInput == 'ayuda') {
      addBotMessage('Hola, soy el bot de SaveUp.\n'
        'Selecciona una opción:\n'
        '1. Correo de SaveUp\n'
        '2. Contactar con un asesor\n'
        '3. Libro de Reclamaciones\n'
        '(s/n) ¿Desea continuar?');
      waitingForUserInput = true;
      askingToContinue = false;
    } else if (waitingForUserInput) {
      if (userInput.startsWith('1')) {
        addBotMessage('El correo de SaveUp es: SaveUp@gmail.com');
        askingToContinue = true;
      } else if (userInput.startsWith('2')) {
        addBotMessage('Hola soy Pedro y te ayudaré en tus consultas');
        askingToContinue = true;
      } else if (userInput.startsWith('3')) {
        addBotMessage('Libro de Reclamaciones abierto');
        askingToContinue = true;
      } else if (askingToContinue) {
        if (userInput == 's') {
          addBotMessage('Selecciona una opción:\n'
            '1. Correo de SaveUp\n'
            '2. Contactar con un asesor\n'
            '3. Libro de Reclamaciones');
          askingToContinue = false;
        } else if (userInput == 'n') {
          addBotMessage('¡Gracias por usar el servicio de SaveUp!\n'
          'Si desea seguir preguntando escriba "ayuda"'); // Despedida
          askingToContinue = false;
          waitingForUserInput = false;

        } else {
          addBotMessage('Opción incorrecta, vuelve a digitar.');
        }
      } else {
        addBotMessage('Opción incorrecta, vuelve a digitar.');
      }
    } else {
      addBotMessage('Palabra incorrecta, vuelve a digitar.');
    }
    notifyListeners();
    moveScrollToBottom();
  }

  void addBotMessage(String text) {
    final botMessage = Message(text: text, fromWho: FromWho.bot);
    messageList.add(botMessage);
  }

  

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeOut
    );
  }
}
