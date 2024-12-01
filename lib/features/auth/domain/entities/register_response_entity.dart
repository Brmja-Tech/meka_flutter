import 'package:equatable/equatable.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

class RegisterResponseEntity extends Equatable{
  final UserEntity user;
  final String token;
  final int otp;

  const RegisterResponseEntity({required this.user, required this.token, required this.otp});

  @override
  List<Object?> get props => [user, token, otp];
}