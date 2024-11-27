import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';

class GetChatRoomsUseCase extends BaseUseCase<List<ChatRoomEntity>,PaginationParams>{
  final ChatRepository _chatRepository;

  GetChatRoomsUseCase(this._chatRepository);
  @override
  Future<Either<Failure, List<ChatRoomEntity>>> call(PaginationParams params) {
    return _chatRepository.fetchChatRooms(params);
  }
  
}