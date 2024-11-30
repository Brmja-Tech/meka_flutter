import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/widgets/chat_bottom_text_field.dart';
import 'package:meka/features/chat/presentation/widgets/chat_list.dart';

class ChatRoomScreen extends StatelessWidget {
  final int chatRoomIndex;

  const ChatRoomScreen({super.key, required this.chatRoomIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(context
              .read<ChatBloc>()
              .state
              .chatRooms[chatRoomIndex]
              .receiverName),
          centerTitle: true,
        ),
        body: Column(
          // alignment: Alignment.bottomCenter,
          children: [
            Expanded(
              child: ChatList(
                chatRoomIndex: chatRoomIndex,
              ),
            ),
            ChatBottomTextField(
              roomId:
                  context.read<ChatBloc>().state.chatRooms[chatRoomIndex].chatId,
            )
          ],
        ),
      ),
    );
  }
}
