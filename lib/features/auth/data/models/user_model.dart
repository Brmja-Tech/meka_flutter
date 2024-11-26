import 'package:meka/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.id,
      required super.email,
      required super.name,
       super.imageUrl,
      required super.phoneNumber,
      required super.userType});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json ['id'],
      email: json['email'],
      name: json['name'],
      imageUrl: json['image'],
      phoneNumber: json['phone'],
      userType: json['user_type'],
    );
  }
}
