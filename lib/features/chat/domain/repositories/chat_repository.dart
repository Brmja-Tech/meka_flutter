import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/typedefs/app_typedefs.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  void listenForMessages(DynamicListener onEvent);
  Future<void> closeConnection();

  Future<Either<Failure, void>> sendMessage(SendMessageParams params);

  Future<Either<Failure, void>> fetchMessages(String chatId);

  Future<Either<Failure, List<ChatRoomEntity>>> fetchChatRooms(PaginationParams params);

  Future<Either<Failure, void>> createChatRoom(CreateRoomParams params);
}
