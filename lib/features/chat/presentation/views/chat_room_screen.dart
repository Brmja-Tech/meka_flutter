import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/widgets/chat_bottom_text_field.dart';
import 'package:meka/features/chat/presentation/widgets/chat_list.dart';
import 'package:meka/service_locator/service_locator.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('علي مازن'),
        centerTitle: true,
      ),
      body: const Column(
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
