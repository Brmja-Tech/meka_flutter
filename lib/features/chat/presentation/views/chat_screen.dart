import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_state.dart';
import 'package:meka/features/chat/presentation/views/chat_room_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()..fetchChatRooms(),
      child: Scaffold(body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: 30,
              itemBuilder: (context, index) {
                final room = state.chatRooms[index];
                return _buildChatRoomTile(room);
              });
        },
      )),
    );
  }

  Widget _buildChatRoomTile(ChatRoomEntity room) {
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
        room.userId.toString(),
        style: context.textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(
          room.replies.last.message, style: context.textTheme.bodyMedium!),
      trailing: Text(
          room.replies.last.createdAt, style: context.textTheme.bodyMedium!),
    );
  }
}
