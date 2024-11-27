import 'package:equatable/equatable.dart';

class RepliesEntity extends Equatable{
  final int id;
  final int userId;
  final String message;
  final String createdAt;

  const RepliesEntity({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, message, createdAt];
}