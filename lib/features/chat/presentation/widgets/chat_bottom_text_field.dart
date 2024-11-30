import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';

class ChatBottomTextField extends StatefulWidget {
  final int roomId;
  const ChatBottomTextField({super.key, required this.roomId});

  @override
  State<ChatBottomTextField> createState() => _ChatBottomTextFieldState();
}

class _ChatBottomTextFieldState extends State<ChatBottomTextField> {
  final TextEditingController _messageTextController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    // _messageFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _messageTextController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageTextController.text.trim().isNotEmpty) {
     context.read<ChatBloc>().sendMessage(_messageTextController.text.trim(),widget.roomId);
      _messageTextController.clear();
      _messageFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 40.h,
                maxHeight: context.screenHeight*0.1
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _messageTextController,
                focusNode: _messageFocusNode,
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالة',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),

          // Send button
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
