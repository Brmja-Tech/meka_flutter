import 'package:meka/features/chat/data/models/replies_model.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatRoomEntity {
  const ChatModel(super.chatId, super.replies);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        json['chatId'],
        (json['replies'] as List)
            .map((e) => RepliesModel.fromJson(e))
            .toList());
  }
}
