import 'package:equatable/equatable.dart';
import 'package:meka/features/chat/domain/entities/replies_entity.dart';

class ChatRoomEntity extends Equatable {
  final int chatId;
  final List<RepliesEntity> replies;

  const ChatRoomEntity(this.chatId, this.replies);

  @override
  List<Object?> get props => [chatId, replies];
}

