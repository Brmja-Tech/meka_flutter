import 'package:meka/features/chat/data/models/replies_model.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatRoomEntity {
  const ChatModel({
    required super.chatId,
    required super.replies,
    required super.userId,
    super.title,
    super.receiverId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        chatId:  json['id'],
        userId: json['user_id'],
        title: json['title'],
        receiverId: json['receiver_id'],
        replies: (json['replies'] as List)
            .map((e) => RepliesModel.fromJson(e))
            .toList());
  }
}
