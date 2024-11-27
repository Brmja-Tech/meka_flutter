import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/domain/usecases/create_room_use_case.dart';
import 'package:meka/features/chat/domain/usecases/fetch_chat_rooms.dart';
import 'package:meka/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:meka/features/chat/domain/usecases/send_message_use_case.dart';
import 'chat_state.dart';

class ChatBloc extends Cubit<ChatState> {
  ChatBloc(this._getChatRoomsUseCase, this._createRoomUseCase,
      this._sendMessageUseCase, this._getMessagesUseCase)
      : super(const ChatState());
  final GetChatRoomsUseCase _getChatRoomsUseCase;
  final CreateRoomUseCase _createRoomUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;

  Future<void> fetchChatRooms() async {
    emit(state.copyWith(status: ChatStateStatus.loading));
    final result =
        await _getChatRoomsUseCase.call(PaginationParams(page: 1, limit: 10));
    result.fold(
        (l) => emit(state.copyWith(
            errorMessage: l.message, status: ChatStateStatus.failure)),
        (r) => emit(
            state.copyWith(status: ChatStateStatus.success, chatRooms: r)));
  }

  Future<void> createChatRoom(
      {String? title, int? receiverId, required int userId}) async {
    emit(state.copyWith(status: ChatStateStatus.loading));
    final result = await _createRoomUseCase.call(
        CreateRoomParams(userId: userId, receiverId: receiverId, title: title));
    result.fold(
        (l) => emit(state.copyWith(
            errorMessage: l.message, status: ChatStateStatus.failure)),
        (r) => emit(state.copyWith(status: ChatStateStatus.success)));
  }

  Future<void> sendMessage(String message) async {
    emit(state.copyWith(status: ChatStateStatus.loading));
    final result = await _sendMessageUseCase.call(message);
    result.fold(
        (l) => emit(state.copyWith(
            errorMessage: l.message, status: ChatStateStatus.failure)),
        (r) => emit(state.copyWith(status: ChatStateStatus.success)));
  }

  Future<void> fetchMessages(int roomId) async {
    emit(state.copyWith(status: ChatStateStatus.loading));
    final result = await _getMessagesUseCase.call(roomId.toString());
    result.fold(
        (l) => emit(state.copyWith(
            errorMessage: l.message, status: ChatStateStatus.failure)),
        (r) => emit(state.copyWith(status: ChatStateStatus.success)));
  }
}
