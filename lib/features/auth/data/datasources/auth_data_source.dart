import 'package:equatable/equatable.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/firebase_helper/firebase_consumer.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';

abstract class AuthDataSource {
  Future<Either<Failure, void>> login(LoginParams params);

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
  Future<Either<Failure, void>> login(LoginParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.login, data: params.toJson());
    return result.fold((l) => Left(l), (r) {
      CacheManager.saveAccessToken(r['access_token']);
      _apiConsumer.updateHeader(r['access_token']);
      return Right(null);
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
  Future<Either<Failure, void>> facebookLogin(LoginParams params) {
    // TODO: implement facebookLogin
    throw UnimplementedError();
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
  final String? email;
  final String? password;
  final int role;
  final String type;

  Map<String, dynamic> toJson() => {
        'email': email,
        'role': role,
        'type': type,
        if (password != null) 'password': password,
      };

  const LoginParams(
      {this.email, this.password, required this.role, required this.type});

  @override
  List<Object?> get props => [email, password];
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
