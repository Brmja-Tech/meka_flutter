import 'package:equatable/equatable.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

enum UserStatus { initial, loading, success, failure, noInternet, noDataFound }

extension UserStatusX on UserState {
  bool get isInitial => status == UserStatus.initial;

  bool get isLoading => status == UserStatus.loading;

  bool get isSuccess => status == UserStatus.success;

  bool get isError => status == UserStatus.failure;

  bool get isNoInternet => status == UserStatus.noInternet;

  bool get isNoDataFound => status == UserStatus.noDataFound;
}

class UserState extends Equatable {
  final UserStatus status;
  final String errorMessage;
  final UserEntity? user;

  const UserState({
    this.status = UserStatus.initial,
    this.errorMessage = '',
    this.user,
  });

  UserState copyWith({
    UserStatus? status,
    String? errorMessage,
    UserEntity? user,
  }) =>
      UserState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [status, errorMessage, user];
}
