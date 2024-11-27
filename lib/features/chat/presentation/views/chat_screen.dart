import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/chat/presentation/views/chat_room_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: 30,
            itemBuilder: (context, index) {
              return _buildChatRoomTile();
            }));
  }

  Widget _buildChatRoomTile() {
    return ListTile(
      style: ListTileStyle.list,
      onTap: () {
        context.go(const ChatRoomScreen());
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(Icons.person),
      ),
      title: Text(
        'علي مازن',
        style: context.textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text('مرحبا, كيف الحال؟', style: context.textTheme.bodyMedium!),
      trailing: Text('12:28 ص', style: context.textTheme.bodyMedium!),
    );
  }
}
