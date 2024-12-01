import 'package:meka/features/auth/data/models/user_model.dart';
import 'package:meka/features/auth/domain/entities/register_response_entity.dart';

class RegisterResponseModel extends RegisterResponseEntity {
  const RegisterResponseModel(
      {required super.user, required super.token, required super.otp});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
        user: UserModel.fromJson(json['user']),
        token: json['token'],
        otp: json['otp'] is int ? json['otp'] : int.tryParse(json['otp'].toString()) ?? 0,
    );}
}
