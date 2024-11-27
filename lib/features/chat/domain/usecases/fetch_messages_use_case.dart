import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesUseCase extends BaseUseCase<void,String>{
  final ChatRepository _chatRepository;

  GetMessagesUseCase(this._chatRepository);
  @override
  Future<Either<Failure, void>> call(String params) {
    return _chatRepository.fetchMessages(params);
  }

}