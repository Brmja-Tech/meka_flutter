import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';

abstract class ChatRepository {
  void setupRealTimeChat();

  Future<Either<Failure, void>> sendMessage(SendMessageParams params);

  Future<Either<Failure, void>> fetchMessages(PaginationParams params);

}
