import 'package:equatable/equatable.dart';

enum AuthStatus { loading, initial, success, failure }

extension AuthStatusX on AuthStatus {
  bool get isInitial => this == AuthStatus.initial;
  bool get isSuccess => this == AuthStatus.success;
  bool get isError => this == AuthStatus.failure;
  bool get isLoading => this == AuthStatus.loading;
}

class AuthState extends Equatable {

  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [];
}
