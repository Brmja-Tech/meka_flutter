import 'package:meka/core/network/base_use_case/base_use_case.dart';

import 'package:meka/core/network/failure/failure.dart';

import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/typedefs/app_typedefs.dart';

import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<Either<Failure, void>> createChatRoom(CreateRoomParams params) {
    return _chatDataSource.createChatRoom(params);
  }

  @override
  Future<Either<Failure, List<ChatRoomEntity>>> fetchChatRooms(
      PaginationParams params) {
    return _chatDataSource.fetchChatRooms(params);
  }

  @override
  Future<Either<Failure, void>> fetchMessages(String chatId) {
    return _chatDataSource.fetchMessages(chatId);
  }

  @override
  void listenForMessages(DynamicListener onEvent) {
    return _chatDataSource.listenForMessages(onEvent);
  }

  @override
  Future<void> closeConnection() {
    return _chatDataSource.closeConnection();
  }

  @override
  Future<Either<Failure, void>> sendMessage(SendMessageParams params) {
    return _chatDataSource.sendMessage(params);
  }
}
