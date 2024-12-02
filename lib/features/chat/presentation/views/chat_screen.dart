import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/core/theme/app_colors.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_state.dart';
import 'package:meka/features/chat/presentation/views/chat_room_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.chatRooms.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.message_outlined,
                      size: 50,
                      color: Colors.red,
                    ),
                    Gaps.v48(),
                    Text(
                      'لا توجد محادثات \n قم بطلب رحلات لتستطيع الدردشه مع العملاء',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.chatRooms.length,
                itemBuilder: (context, index) {
                  final room = state.chatRooms[index];
                  return _buildChatRoomTile(room, index, context);
                });
          },
        ));
  }

  Widget _buildChatRoomTile(
      ChatRoomEntity room, int index, BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      onTap: () {
        context.go(BlocProvider.value(
          value: sl<ChatBloc>(),
          child: ChatRoomScreen(
            chatRoomIndex: index,
          ),
        ));
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.secondaryColor,
        child: SvgPicture.asset('assets/svg/app_logo.svg'),
      ),
      title: Text(
        room.receiverName.toString(),
        style: context.textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(room.replies.isEmpty ? '' : room.replies.last.message,
          style: context.textTheme.bodyMedium!),
      trailing: Text(room.replies.isEmpty ? '' : room.replies.last.createdAt,
          style: context.textTheme.bodyMedium!),
    );
  }
}
