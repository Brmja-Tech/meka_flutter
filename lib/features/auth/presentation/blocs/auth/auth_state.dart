import 'package:equatable/equatable.dart';
import 'package:meka/features/auth/domain/entities/register_response_entity.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  loading,
  isRequestingOTP,
  initial,
  success,
  failure,
  oTPSent,
  otPResent,
  verified,
  socialAuthSuccess
}

extension AuthStatusX on AuthState {
  bool get isInitial => status == AuthStatus.initial;

  bool get isSuccess => status == AuthStatus.success;

  bool get isError => status == AuthStatus.failure;

  bool get isLoading => status == AuthStatus.loading;

  bool get isOTPSent => status == AuthStatus.oTPSent;

  bool get isVerified => status == AuthStatus.verified;

  bool get isOTPResent => status == AuthStatus.otPResent;

  bool get isSocialAuthSuccess => status == AuthStatus.socialAuthSuccess;

  bool get isRequestingOTP => status == AuthStatus.isRequestingOTP;
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final RegisterResponseEntity? registerResponseEntity;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.registerResponseEntity,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    RegisterResponseEntity? registerResponseEntity,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      registerResponseEntity:
          registerResponseEntity ?? this.registerResponseEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, user, registerResponseEntity];
}
