import 'dart:convert';
import 'package:meka/core/helper/functions.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/socket/pusher_consumer.dart';

abstract class ChatDataSource {
  void setupRealTimeChat();

  Future<Either<Failure, void>> sendMessage(SendMessageParams params);

  Future<Either<Failure, void>> fetchMessages(PaginationParams params);
}

class ChatDataSourceImpl extends ChatDataSource {
  final PusherConsumer _pusherConsumer;
  final ApiConsumer _apiConsumer;

  ChatDataSourceImpl(this._pusherConsumer, this._apiConsumer);

  @override
  void setupRealTimeChat() {
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
  Future<Either<Failure, void>> sendMessage(SendMessageParams params) async {
    final result = await _apiConsumer.post('chats', data: params.toJson());
    return result.fold((left) => Left(left), (r) => Right(null));
  }

  @override
  Future<Either<Failure, void>> fetchMessages(PaginationParams params) async {
    final result = await _apiConsumer.get('chats');
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}

class SendMessageParams {
  final int userId;
  final String title;

  SendMessageParams({required this.userId, required this.title});

  Map<String, dynamic> toJson() => {"user_id": userId, "title": title};
}
