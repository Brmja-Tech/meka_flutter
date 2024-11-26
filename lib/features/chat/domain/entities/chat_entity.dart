import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final int chatId;
  final List<Replies> replies;

  const ChatEntity(this.chatId, this.replies);

  @override
  // TODO: implement props
  List<Object?> get props => [chatId, replies];
}

class Replies {}
