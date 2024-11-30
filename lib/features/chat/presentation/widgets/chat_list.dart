import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_cubit.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_state.dart';

class ChatList extends StatefulWidget {
  final int chatRoomIndex;

  const ChatList({super.key, required this.chatRoomIndex});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = context.read<ChatBloc>().scrollController;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }
        });
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView.builder(
              itemCount: state.chatRooms[widget.chatRoomIndex].replies.length,
              // shrinkWrap: true,
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemBuilder: (_, index) {
                final user = context.read<UserBloc>().state.user;
                final message =
                    state.chatRooms[widget.chatRoomIndex].replies[index];
                if (message.userId == user!.id) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: context.screenWidth * 0.3,
                              maxWidth: context.screenWidth * 0.7),
                          alignment: AlignmentDirectional.centerEnd,
                          padding: EdgeInsets.all(15.w),
                          margin: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 30.h),
                          // width: context.screenWidth * 0.3,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex('#E5EBFC'),
                              borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r))
                                  .add(BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(20.r)))),
                          child: Text(
                            message.message,
                            style: context.textTheme.bodyLarge!.copyWith(),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: context.screenWidth * 0.3,
                            maxWidth: context.screenWidth * 0.7),
                        padding: EdgeInsets.all(15.w),
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        // width: context.screenWidth * 0.3,
                        alignment: AlignmentDirectional.centerStart,
                        decoration: BoxDecoration(
                            color: HexColor.fromHex('#004CFF'),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20.r))
                                    .add(BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(20.r)))),
                        child: Text(
                          message.message,
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}
