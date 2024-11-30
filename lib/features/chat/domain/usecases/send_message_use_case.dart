import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase extends BaseUseCase<void, SendMessageParams> {
  final ChatRepository _chatRepository;

  SendMessageUseCase(this._chatRepository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) {
    return _chatRepository.sendMessage(params);
  }
}
