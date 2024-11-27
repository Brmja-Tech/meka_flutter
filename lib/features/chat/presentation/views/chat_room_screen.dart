import 'package:flutter/material.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/features/chat/presentation/widgets/chat_bottom_text_field.dart';
import 'package:meka/features/chat/presentation/widgets/chat_list.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('علي مازن'),
        centerTitle: true,
      ),
      body:  const Column(
        // alignment: Alignment.bottomCenter,
        children: [
          Expanded(
            child: ChatList(),
          ),
          ChatBottomTextField()
        ],
      ),
    );
  }
}
