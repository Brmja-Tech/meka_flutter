import 'package:meka/features/chat/domain/entities/replies_entity.dart';

class RepliesModel extends RepliesEntity {
  const RepliesModel(
      {required super.id,
      required super.userId,
      required super.message,
      required super.createdAt});

  factory RepliesModel.fromJson(Map<String, dynamic> json) {
    return RepliesModel(
        id: json['id'],
        userId: json['user_id'],
        message: json['message'],
        createdAt: json['created_at']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'message': message,
        'created_at': createdAt
      };
}
