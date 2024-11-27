import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';

class CreateRoomUseCase extends BaseUseCase<void,CreateRoomParams>{
  final ChatRepository _chatRepository;

  CreateRoomUseCase(this._chatRepository);
  @override
  Future<Either<Failure, void>> call(CreateRoomParams params) {
    return _chatRepository.createChatRoom(params);
  }

}