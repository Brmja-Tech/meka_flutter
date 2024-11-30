import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/core/network/socket/channels.dart';
import 'package:meka/core/network/socket/events.dart';
import 'package:meka/core/network/socket/pusher_consumer.dart';
import 'package:meka/core/typedefs/app_typedefs.dart';
import 'package:meka/features/chat/data/models/chat_model.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

abstract class ChatDataSource {
  void listenForMessages(DynamicListener onEvent);

  Future<void> closeConnection();

  //removed because 2 listen for same channel
  // void listenForChatRooms();

  Future<Either<Failure, void>> sendMessage(SendMessageParams params);

  Future<Either<Failure, void>> fetchMessages(String chatId);

  Future<Either<Failure, List<ChatRoomEntity>>> fetchChatRooms(
      PaginationParams params);

  Future<Either<Failure, void>> createChatRoom(CreateRoomParams params);
}

class ChatDataSourceImpl extends ChatDataSource {
  final PusherConsumer _pusherConsumer;
  final ApiConsumer _apiConsumer;

  ChatDataSourceImpl(this._pusherConsumer, this._apiConsumer);

  @override
  Future<void> closeConnection() {
    return _pusherConsumer.disconnect();
  }

  @override
  Future<void> listenForMessages(DynamicListener onEvent) async {
    try {
      await _pusherConsumer.initialize();
      await _pusherConsumer.connect();
      _pusherConsumer.subscribe(PusherChannels.newMessage);
      _pusherConsumer.bind(PusherChannels.newMessage, EventListeners.newMessage,
          (data) {
        try {
          onEvent(data);
        } catch (e) {
          log('Error parsing message: $e');
        }
      });
      log('Listening for new chat messages...');
    } catch (e) {
      log('Error initializing or subscribing to Pusher: $e');
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(SendMessageParams params) async {
    final result = await _apiConsumer.post(
        EndPoints.sendMessage(params.roomId.toString()),
        data: params.toJson());
    return result.fold((left) => Left(left), (r) => Right(null));
  }

  @override
  Future<Either<Failure, void>> fetchMessages(String chatId) async {
    final result = await _apiConsumer.get(EndPoints.getMessages(chatId));
    return result.fold((l) => Left(l), (r) {
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> createChatRoom(CreateRoomParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.createRoom, data: params.toJson());
    return result.fold((l) => Left(l), (r) => Right(null));
  }

  @override
  Future<Either<Failure, List<ChatRoomEntity>>> fetchChatRooms(
      PaginationParams params) async {
    final result = await _apiConsumer.get(EndPoints.getRooms,
        queryParameters: params.toJson());
    return result.fold((l) => Left(l), (r) {
      final rooms =
          (r['data'] as List).map((e) => ChatModel.fromJson(e)).toList();
      return Right(rooms);
    });
  }
}

class CreateRoomParams {
  final int userId;
  final int? receiverId;
  final String? title;

  CreateRoomParams({
    required this.userId,
    this.title,
    this.receiverId,
  });

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "title": title,
        if (receiverId != null) "receiver_id": receiverId
      };
}

class SendMessageParams extends Equatable {
  final String message;
  final int roomId;

  const SendMessageParams({required this.message, required this.roomId});

  Map<String, dynamic> toJson() => {
        "message": message,
      };

  @override
  List<Object?> get props => [message, roomId];
}
