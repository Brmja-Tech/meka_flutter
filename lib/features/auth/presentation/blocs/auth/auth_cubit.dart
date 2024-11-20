import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/usecases/login_use_case.dart';
import 'package:meka/features/auth/domain/usecases/logout_use_case.dart';
import 'package:meka/features/auth/domain/usecases/register_use_case.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;

  AuthCubit(this._logoutUseCase, this._loginUseCase, this._registerUseCase)
      : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result =
        await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> register(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _registerUseCase(
        RegisterParams(email: email, password: password));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }
}
