import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/color_extension.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_state.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return ListView.builder(
            itemCount: state.chatRooms.length,
            // shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            itemBuilder: (_, index) {
              if (index % 2 == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          minWidth: context.screenWidth * 0.3,
                          maxWidth: context.screenWidth * 0.7
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      padding: EdgeInsets.all(15.w),
                      margin:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                      // width: context.screenWidth * 0.3,
                      decoration: BoxDecoration(
                          color: HexColor.fromHex('#E5EBFC'),
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)).add(
                              BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(20.r)))),
                      child: const Text(
                        'Admin Chat ffk sfhk c;sdkhjkf hfoiirn vor jrjof voejre hfref hvuik',
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        minWidth: context.screenWidth * 0.3,
                        maxWidth: context.screenWidth * 0.7
                    ),
                    padding: EdgeInsets.all(15.w),
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    // width: context.screenWidth * 0.3,
                    alignment: AlignmentDirectional.centerStart,
                    decoration: BoxDecoration(
                        color: HexColor.fromHex('#004CFF'),
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)).add(
                            BorderRadiusDirectional.only(
                                bottomEnd: Radius.circular(20.r)))),
                    child: Text(
                      'Driver Chat ffk sfhk c;sdkhjkf hfoiirn vor jrjof voejre hfref hvuik',
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
