import 'dart:convert';
import 'package:meka/core/helper/functions.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/core/network/socket/pusher_consumer.dart';
import 'package:meka/features/chat/data/models/chat_model.dart';
import 'package:meka/features/chat/domain/entities/chat_entity.dart';

abstract class ChatDataSource {
  void listenForMessages();

  void listenForChatRooms();

  Future<Either<Failure, void>> sendMessage(String message);

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
  void listenForMessages() {
    // Subscribe to the channel for chat updates
    _pusherConsumer
        .subscribe('new-chat'); // Replace 'chat-channel' with your channel name

    // Bind to a specific event for new messages
    _pusherConsumer.bind('new-chat', 'chat', (data) {
      // Parse the incoming message data
      final message = parseMessageData(data);

      // Handle the new message (e.g., add to the UI or update state)
      handleNewMessage(message);
    });
  }

// Helper to parse incoming message data
  dynamic parseMessageData(String? data) {
    if (data == null) return null;
    try {
      return jsonDecode(data);
    } catch (e) {
      logger('Error parsing message data: $e');
      return null;
    }
  }

// Handle the new message
  void handleNewMessage(dynamic message) {
    if (message != null) {
      // Update your chat UI or state management here
      logger('Received new message: $message');
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String message) async {
    final result = await _apiConsumer.post('chats', data: {"message": message});
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

  @override
  void listenForChatRooms() {
    // TODO: implement listenForChatRooms
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
