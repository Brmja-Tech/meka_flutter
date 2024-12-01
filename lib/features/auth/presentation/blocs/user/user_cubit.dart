import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/usecases/get_user_profile_use_case.dart';
import 'package:meka/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_state.dart';
import 'package:meka/main.dart';

class UserBloc extends Cubit<UserState> {
  UserBloc(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const UserState());
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  static UserBloc get to => navigatorKey.currentContext!.read<UserBloc>();

  Future<void> getUser() async {
    emit(state.copyWith(status: UserStatus.loading));
    final result = await _getProfileUseCase(const NoParams());
    result.fold(
        (left) => emit(state.copyWith(
            errorMessage: left.message, status: UserStatus.failure)), (r) {
      emit(state.copyWith(user: r, status: UserStatus.success));
    });
  }

  Future<void> updateProfile(
      {required String email,
      required String password,
      required String phone,
      required String name,
      required int type}) async {
    emit(state.copyWith(status: UserStatus.loading));
    final result = await _updateProfileUseCase(RegisterParams(
        email: email,
        password: password,
        phone: phone,
        type: type,
        name: name, fcmToken: ''));
    result.fold(
        (left) => emit(state.copyWith(
            errorMessage: left.message, status: UserStatus.failure)), (r) {
      emit(state.copyWith(user: r, status: UserStatus.success));
    });
  }
}
