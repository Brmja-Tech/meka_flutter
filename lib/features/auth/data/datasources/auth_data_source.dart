import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/firebase_helper/firebase_consumer.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<Either<Failure, UserModel>> login(LoginParams params);

  Future<Either<Failure, void>> googleLogin(LoginParams params);

  Future<Either<Failure, void>> facebookLogin(LoginParams params);

  Future<Either<Failure, void>> appleLogin(LoginParams params);

  Future<Either<Failure, void>> register(RegisterParams params);

  Future<Either<Failure, void>> logout(NoParams params);

  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params);

  Future<Either<Failure, void>> sendOTP(NoParams params);
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiConsumer _apiConsumer;
  final FirebaseApiConsumer _firebaseApiConsumer = BaseFirebaseApiConsumer();

  AuthDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, UserModel>> login(LoginParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.login, data: params.toJson());
    return result.fold((l) => Left(l), (r) async {
      log('token is  ${r['data']['token']}');
      log('user is  ${r['data']['user']}');
      await CacheManager.saveAccessToken(r['data']['token']);
      _apiConsumer.updateHeader({"Authorization": ' Bearer ${r['data']['token']}'});
      final user = UserModel.fromJson(r['data']['user']);
      log('user is from api ${user.email}');
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.register, data: params.toJson());
    return result.fold((l) => Left(l), (r) {
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> logout(NoParams params) async {
    final result = await _apiConsumer.post(EndPoints.register);
    return result.fold((l) => Left(l), (r) {
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> appleLogin(LoginParams params) {
    // TODO: implement appleLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> facebookLogin(LoginParams params) async {
    final result = await _firebaseApiConsumer.loginWithFacebook();
    return result.fold((l) => Left(l), (r) {
      log('token is ${r.uid}');
      // login(LoginParams(email: r.email!, role: params.role, type: params.type));
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> googleLogin(LoginParams params) async {
    final result = await _firebaseApiConsumer.loginWithGoogle();
    return result.fold((l) => Left(l), (r) {
      // login(LoginParams(email: r.email!, role: params.role, type: params.type));
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendOTP(NoParams params) {
    // TODO: implement sendOTP
    throw UnimplementedError();
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
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  const RegisterParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final class ResetPasswordParams extends Equatable {
  final String email;
  final String password;

  const ResetPasswordParams({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  @override
  List<Object?> get props => [email, password];
}
