import 'package:meka/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id']);
  }
}