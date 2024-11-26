import 'package:flutter/material.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/service_locator/service_locator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () async {
              // final result = await sl<ApiConsumer>().post('chats', data: {
              //   'title': "Hello World",
              //   "user_id": 2,
              // });
              // result.fold((left)=>Left(left), (r){
              //
              // });
            },
            child: Text('Send'))
      ],
    );
  }
}
