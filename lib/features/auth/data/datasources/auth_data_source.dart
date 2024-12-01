import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/firebase_helper/firebase_consumer.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/features/auth/data/models/register_response_model.dart';
import 'package:meka/features/auth/data/models/user_model.dart';
import 'package:meka/features/auth/domain/entities/register_response_entity.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<Either<Failure, RegisterResponseEntity>> register(RegisterParams params);

  Future<Either<Failure, UserEntity>> oTPVerify(OTPVerifyParams params);

  Future<Either<Failure, void>> sendOTP(SendOTPParams params);

  Future<Either<Failure, UserEntity>> login(LoginParams params);

  Future<Either<Failure, void>> googleLogin(NoParams noParams);

  Future<Either<Failure, void>> facebookLogin(NoParams noParams);

  Future<Either<Failure, void>> appleLogin(NoParams noParams);

  Future<Either<Failure, void>> forgetPassword(ForgetPasswordParams params);

  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params);

  Future<Either<Failure, UserEntity>> getUserProfile(NoParams params);

  Future<Either<Failure, UserEntity>> updateProfile(RegisterParams params);

  Future<Either<Failure, void>> logout(NoParams params);
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiConsumer _apiConsumer;
  final FirebaseApiConsumer _firebaseApiConsumer = BaseFirebaseApiConsumer();

  AuthDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.login, data: params.toJson());
    return result.fold((l) => Left(l), (r) async {
      log('token is  ${r['data']['token']}');
      log('user is  ${r['data']['user']}');
      await CacheManager.saveAccessToken(r['data']['token']);
      _apiConsumer
          .updateHeader({"Authorization": ' Bearer ${r['data']['token']}'});
      final user = UserModel.fromJson(r['data']['user']);
      log('user is from api ${user.email}');
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, RegisterResponseEntity>> register(RegisterParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.register, data: params.toJson());
    return result.fold((l) => Left(l), (r) async{
      await CacheManager.saveAccessToken(r['data']['token']);
      _apiConsumer
          .updateHeader({"Authorization": ' Bearer ${r['data']['token']}'});

      return Right(RegisterResponseModel.fromJson(r['data']));
    });
  }

  @override
  Future<Either<Failure, void>> logout(NoParams params) async {
    final result = await _apiConsumer.post(EndPoints.logout);
    return result.fold((l) => Left(l), (r) {
      CacheManager.clear();
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> appleLogin(NoParams noParams) {
    // TODO: implement appleLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> facebookLogin(NoParams noParams) async {
    final result = await _firebaseApiConsumer.loginWithFacebook();
    return result.fold((l) => Left(l), (r) {
      log('token is ${r.user!.uid}');

      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> googleLogin(NoParams noParams) async {
    final result = await _firebaseApiConsumer.loginWithGoogle();
    return result.fold((l) => Left(l), (r) async {
      final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      final socialAuth = await _socialLogin(SocialAuthParams(
        email: r.user!.email!,
        name: r.user!.displayName!,
        providerType: 'google',
        providerId: r.credential!.providerId,
        fcmToken: fcmToken,
      ));
      socialAuth.fold((l) => Left(l), (r) {});
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendOTP(SendOTPParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.sendOTP, data: params.toJson());
    return result.fold((l) => Left(l), (r) => Right(null));
  }

  @override
  Future<Either<Failure, void>> forgetPassword(
      ForgetPasswordParams params) async {
    final result = await _apiConsumer.post(EndPoints.forgetPassword,
        data: params.toJson());
    return result.fold((l) => Left(l), (r) => Right(null));
  }

  @override
  Future<Either<Failure, UserModel>> getUserProfile(NoParams params) async {
    final result = await _apiConsumer.get(EndPoints.getProfile);
    return result.fold((l) => Left(l), (r) {
      return Right(UserModel.fromJson(r['data']));
    });
  }

  @override
  Future<Either<Failure, UserEntity>> oTPVerify(OTPVerifyParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.verifyOTP, data: params.toJson());
    return result.fold(
        (l) => Left(l), (r) => Right(UserModel.fromJson(r['data'])));
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
      RegisterParams params) async {
    final result = await _apiConsumer.post(EndPoints.updateProfile);
    return result.fold(
        (l) => Left(l), (r) => Right(UserModel.fromJson(r['data'])));
  }

  Future<Either<Failure, UserEntity>> _socialLogin(
      SocialAuthParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.socialLogin, data: params.toJson());
    return result.fold(
        (l) => Left(l), (r) => Right(UserModel.fromJson(r['data'])));
  }
}

class LoginParams extends Equatable {
  final String email;
  final String? password;

  final String? type;
  final String fcmToken;

  Map<String, dynamic> toJson() => {
        'email': email,
        if (type != null) 'type': type,
        'fcm_token': fcmToken,
        if (password != null) 'password': password,
      };

  const LoginParams(
      {required this.email, this.password, this.type, required this.fcmToken});

  @override
  List<Object?> get props => [email, password, type, fcmToken];
}

class RegisterParams extends Equatable {
  final String email;
  final String fcmToken;
  final String password;
  final String phone;
  final int type;
  final String name;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'type': type,
        'fcm_token': fcmToken,
        'name': name,
        'phone': phone,
        'terms_and_conditions': 1
      };

  const RegisterParams(
      {required this.email,
      required this.password,
      required this.phone,
      required this.fcmToken,
      required this.type,
      required this.name});

  @override
  List<Object?> get props => [email, password, phone, type, name, fcmToken];
}

final class ResetPasswordParams extends Equatable {
  final String otp;
  final String password;
  final String passwordConfirm;

  const ResetPasswordParams(
      {required this.otp,
      required this.password,
      required this.passwordConfirm});

  Map<String, dynamic> toJson() => {
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirm
      };

  @override
  List<Object?> get props => [otp, password, passwordConfirm];
}

class OTPVerifyParams extends Equatable {
  final String otp;

  const OTPVerifyParams({required this.otp});

  Map<String, dynamic> toJson() => {'otp': otp};

  @override
  List<Object?> get props => [otp];
}

class SendOTPParams extends Equatable {
  final String email;

  const SendOTPParams({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  @override
  List<Object?> get props => [email];
}

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  @override
  List<Object?> get props => [email];
}

class SocialAuthParams extends Equatable {
  final String email;
  final String name;
  final String providerType;
  final String providerId;
  final String fcmToken;

  const SocialAuthParams(
      {required this.email,
      required this.name,
      required this.providerType,
      required this.providerId,
      required this.fcmToken});

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'provider_type': providerType,
        'provider_id': providerId,
        'terms_and_conditions': 1,
        'fcm_token': fcmToken
      };

  @override
  List<Object?> get props => [email, name, providerType, providerId, fcmToken];
}
