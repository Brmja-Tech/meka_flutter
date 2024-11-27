import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';

abstract class ChatRepository {
  void listenForMessages();

  void listenForChatRooms();

  Future<Either<Failure, void>> sendMessage(String message);

  Future<Either<Failure, void>> fetchMessages(String chatId);

  Future<Either<Failure, void>> fetchChatRooms(PaginationParams params);

  Future<Either<Failure, void>> createChatRoom(CreateRoomParams params);
}
