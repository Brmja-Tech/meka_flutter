import 'package:equatable/equatable.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { loading, initial, success, failure,oTPSent }

extension AuthStatusX on AuthState {
  bool get isInitial => status == AuthStatus.initial;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.failure;
  bool get isLoading => status == AuthStatus.loading;
  bool get isOTPSent => status == AuthStatus.oTPSent;
}

class AuthState extends Equatable {

  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status , errorMessage, user];
}
