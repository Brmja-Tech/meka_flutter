import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';
import 'package:meka/features/auth/domain/usecases/apple_sign_in_use_case.dart';
import 'package:meka/features/auth/domain/usecases/facebook_sign_in_use_case.dart';
import 'package:meka/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:meka/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:meka/features/auth/domain/usecases/login_use_case.dart';
import 'package:meka/features/auth/domain/usecases/logout_use_case.dart';
import 'package:meka/features/auth/domain/usecases/otp_verify_use_case.dart';
import 'package:meka/features/auth/domain/usecases/register_use_case.dart';
import 'package:meka/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:meka/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final FacebookSignInUseCase _facebookSignInUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final SendOTPUseCase _sendOTPUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final OtpVerifyUseCase _otpVerifyUseCase;

  AuthBloc(
      this._logoutUseCase,
      this._loginUseCase,
      this._registerUseCase,
      this._facebookSignInUseCase,
      this._googleSignInUseCase,
      this._appleSignInUseCase,
      this._forgotPasswordUseCase,
      this._sendOTPUseCase,
      this._resetPasswordUseCase,
      this._otpVerifyUseCase)
      : super(const AuthState());

  Future<void> login(String email, String password) async {
    final token = await FirebaseMessaging.instance.getToken() ?? '';
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _loginUseCase(
        LoginParams(email: email, password: password, fcmToken: token));
    result.fold(
      (l) {
        emit(state.copyWith(
            status: AuthStatus.failure, errorMessage: l.message));
      },
      (r) {
        UserEntity? user = r;
        emit(state.copyWith(status: AuthStatus.success, user: user));
      },
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

  Future<void> register(String email, String password, String name,
      String phone, int type) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _registerUseCase(RegisterParams(
        email: email,
        password: password,
        name: name,
        phone: phone,
        type: type));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.oTPSent)),
    );
  }

  Future<void> googleSignIn() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _googleSignInUseCase(const NoParams());
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> facebookSignIn() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _facebookSignInUseCase(const NoParams());
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> appleSignIn() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _appleSignInUseCase(const NoParams());
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result =
        await _forgotPasswordUseCase(ForgetPasswordParams(email: email));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> sendOTP(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _sendOTPUseCase(SendOTPParams(email: email));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> resetPassword(
      {required String otp,
      required String password,
      required String passwordConfirm}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _resetPasswordUseCase(ResetPasswordParams(
      otp: otp,
      password: password,
      passwordConfirm: passwordConfirm,
    ));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  Future<void> verifyOTP(String otp) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _otpVerifyUseCase(OTPVerifyParams(otp: otp));
    result.fold(
      (l) => emit(
          state.copyWith(status: AuthStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }
}
