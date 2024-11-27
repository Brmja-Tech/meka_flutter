import 'package:equatable/equatable.dart';
import 'package:meka/features/chat/domain/entities/replies_entity.dart';

class ChatRoomEntity extends Equatable {
  final int chatId;
  final String? title;
  final int userId;
  final int? receiverId;
  final List<RepliesEntity> replies;

  const ChatRoomEntity(
      {required this.chatId,required this.replies, this.title,required this.userId, this.receiverId});

  @override
  List<Object?> get props => [chatId, replies, title, userId, receiverId];
}