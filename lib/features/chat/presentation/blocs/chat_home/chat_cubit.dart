import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/extensions/string_extension.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/domain/entities/replies_entity.dart';
import 'package:meka/features/chat/domain/usecases/close_connection_use_case.dart';
import 'package:meka/features/chat/domain/usecases/create_room_use_case.dart';
import 'package:meka/features/chat/domain/usecases/fetch_chat_rooms.dart';
import 'package:meka/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:meka/features/chat/domain/usecases/listen_for_chat_events_use_case.dart';
import 'package:meka/features/chat/domain/usecases/send_message_use_case.dart';
import 'chat_state.dart';

class ChatBloc extends Cubit<ChatState> {
  ChatBloc(
      this._getChatRoomsUseCase,
      this._createRoomUseCase,
      this._sendMessageUseCase,
      this._getMessagesUseCase,
      this._listenForChatEventsUseCase,
      this._closeConnectionUseCase)
      : super(const ChatState()) {
    _listenForMessages();
    fetchChatRooms();
  }

  final GetChatRoomsUseCase _getChatRoomsUseCase;
  final CreateRoomUseCase _createRoomUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final ListenForChatEventsUseCase _listenForChatEventsUseCase;
  final CloseConnectionUseCase _closeConnectionUseCase;

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

  Future<void> sendMessage(String message, int chatId) async {
    emit(state.copyWith(status: ChatStateStatus.loading));
    final result = await _sendMessageUseCase(
        SendMessageParams(message: message, roomId: chatId));
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

  void _listenForMessages() {
    _listenForChatEventsUseCase((data) {
      try {
        log('Raw Data $data');
        final reply = jsonDecode(data);
        log('Parsed Data $reply');
        final userId = reply['user_id'];
        final message = reply['message'];
        final chatId = reply['chat_id'];
        final newReply = RepliesEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          userId: userId,
          message: message,
          createdAt: DateTime.now().toUtc().toString().formatUtc(),
        );
        final updatedChatRooms = state.chatRooms.map((chatRoom) {
          if (chatRoom.chatId == chatId) {
            return chatRoom.copyWith(
              replies: List.from(chatRoom.replies)..add(newReply),
            );
          }
          return chatRoom;
        }).toList();

        emit(state.copyWith(
          chatRooms: updatedChatRooms,
          status: ChatStateStatus.success,
        ));
        _scrollToMax();
      } catch (e) {
        emit(state.copyWith(
          errorMessage: 'Failed to parse incoming message: $e',
          status: ChatStateStatus.failure,
        ));
      }
    });
  }

  final ScrollController scrollController = ScrollController();

  void _scrollToMax() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    }
  }

  @override
  Future<Function> close() async {
    await super.close();
    return () {
      _closeConnectionUseCase.call(const NoParams());
      scrollController.dispose();
      log('Connection closed Chat Bloc');
    };
  }
}
