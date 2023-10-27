import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saveup/domain/entities/message.dart';
import 'package:saveup/providers/chat_provider.dart';
import 'package:saveup/widgets/chat/bot_message_bubble.dart';
import 'package:saveup/widgets/chat/my_message_buble.dart';
import 'package:saveup/widgets/shared/message_field_box.dart';

class BotChatScreen extends StatelessWidget {
  const BotChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF67C5C8),
        leading: const Padding(
          padding:  EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/256/4712/4712015.png'),
          ),
        ),
        title: const Text('Bot SaveUp'),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final chatProvider = context.watch<ChatProvide>();


    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: chatProvider.chatScrollController,
                itemCount: chatProvider.messageList.length,
                itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];
                return (message.fromWho==FromWho.bot)
                  ? BotMessageBubble(message: message)
                  : MyMessageBubble(message: message);
              },)
            ),
            MessageFieldBox(
              //onValue: (value) => chatProvider.sendMessage(value),
              onValue:chatProvider.sendMessage,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}