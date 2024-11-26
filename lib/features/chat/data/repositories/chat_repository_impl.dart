import 'package:meka/core/network/base_use_case/base_use_case.dart';

import 'package:meka/core/network/failure/failure.dart';

import 'package:meka/core/network/http/either.dart';

import 'package:meka/features/chat/data/datasources/chat_data_source.dart';

import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<Either<Failure, void>> fetchMessages(PaginationParams params) {
    return _chatDataSource.fetchMessages(params);
  }

  @override
  Future<Either<Failure, void>> sendMessage(SendMessageParams params) {
    return _chatDataSource.sendMessage(params);
  }

  @override
  void setupRealTimeChat() {
    return _chatDataSource.setupRealTimeChat();
  }
}
