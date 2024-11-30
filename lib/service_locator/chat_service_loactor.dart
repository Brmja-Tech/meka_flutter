import 'package:get_it/get_it.dart';
import 'package:meka/features/chat/data/datasources/chat_data_source.dart';
import 'package:meka/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:meka/features/chat/domain/repositories/chat_repository.dart';
import 'package:meka/features/chat/domain/usecases/close_connection_use_case.dart';
import 'package:meka/features/chat/domain/usecases/create_room_use_case.dart';
import 'package:meka/features/chat/domain/usecases/fetch_chat_rooms.dart';
import 'package:meka/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:meka/features/chat/domain/usecases/listen_for_chat_events_use_case.dart';
import 'package:meka/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:meka/features/chat/presentation/blocs/chat_home/chat_cubit.dart';

class ChatServiceLocator{
  static Future<void> execute({required GetIt sl})async{
    sl.registerLazySingleton<ChatDataSource>(() => ChatDataSourceImpl(sl(),sl()));
    sl.registerLazySingleton<ChatRepository>(()=>ChatRepositoryImpl(sl()));
    sl.registerFactory(()=>SendMessageUseCase(sl()));
    sl.registerFactory(()=>GetMessagesUseCase(sl()));
    sl.registerFactory(()=>GetChatRoomsUseCase(sl()));
    sl.registerFactory(()=>CreateRoomUseCase(sl()));
    sl.registerFactory(()=>ListenForChatEventsUseCase(sl()));
    sl.registerFactory(()=>CloseConnectionUseCase(sl()));
    sl.registerLazySingleton(()=>ChatBloc(sl(), sl(), sl(), sl(),sl(),sl()));
}}