import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/typedefs/app_typedefs.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';

class ListenForChatEventsUseCase extends NormalUseCase<void, DynamicListener> {
  final ChatRepository _chatRepository;

  ListenForChatEventsUseCase(this._chatRepository);

  @override
  void call(DynamicListener params) {
    return _chatRepository.listenForMessages(params);
  }
}
