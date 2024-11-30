import 'package:equatable/equatable.dart';
import 'package:meka/features/chat/domain/entities/replies_entity.dart';

class ChatRoomEntity extends Equatable {
  final int chatId;
  final String? title;
  final int userId;
  final int? receiverId;
  final String receiverName;
  final List<RepliesEntity> replies;

  const ChatRoomEntity(
      {required this.chatId,required this.replies, this.title,required this.userId, this.receiverId,required this.receiverName});

  ChatRoomEntity copyWith({
    int? chatId,
    List<RepliesEntity>? replies,
    String? title,
    int? userId,
    int? receiverId,
    String? receiverName,
  }) {
    return ChatRoomEntity(
      chatId: chatId ?? this.chatId,
      replies: replies ?? this.replies,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
    );
  }

  @override
  List<Object?> get props => [chatId, replies, title, userId, receiverId,receiverName];
}