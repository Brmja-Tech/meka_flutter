import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';

class CloseConnectionUseCase extends NormalUseCase<void, NoParams> {
  final ChatRepository _chatRepository;

  CloseConnectionUseCase(this._chatRepository);

  @override
  Future<void> call(NoParams params) async{
    return await  _chatRepository.closeConnection();
  }
}
