import 'package:meka/features/chat/data/models/replies_model.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatRoomEntity {
  const ChatModel({
    required super.chatId,
    required super.replies,
    required super.userId,
    required super.receiverName,
    super.title,
    super.receiverId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        chatId:  json['id'],
        userId: json['user_id'] != null ? json['user_id'] as int : 0,  // Default to 0 if null
        receiverName: json['receiver_name'],
        title: json['title'],
        receiverId: json['receiver_id'],
        replies: (json['replies'] as List)
            .map((e) => RepliesModel.fromJson(e))
            .toList());
  }
}
