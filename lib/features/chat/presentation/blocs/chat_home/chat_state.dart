import 'package:equatable/equatable.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

enum ChatStateStatus { initial, loading, success, failure }

extension ChatStateStatusX on ChatState {
  bool get isInitial => status == ChatStateStatus.initial;

  bool get isLoading => status == ChatStateStatus.loading;

  bool get isSuccess => status == ChatStateStatus.success;

  bool get isError => status == ChatStateStatus.failure;
}

class ChatState extends Equatable {
  final ChatStateStatus status;
  final String? errorMessage;
  final List<ChatRoomEntity> chatRooms;

  const ChatState({
    this.status = ChatStateStatus.initial,
    this.errorMessage,
    this.chatRooms = const [],
  });

  ChatState copyWith({
    ChatStateStatus? status,
    String? errorMessage,
    List<ChatRoomEntity>? chatRooms,
  }) {
    return ChatState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, chatRooms];
}
