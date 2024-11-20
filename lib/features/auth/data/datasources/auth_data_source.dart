import 'package:equatable/equatable.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';

abstract class AuthDataSource {
  Future<Either<Failure, void>> login(LoginParams params);

  Future<Either<Failure, void>> register(RegisterParams params);

  Future<Either<Failure, void>> logout(NoParams params);
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiConsumer _apiConsumer;

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
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  const LoginParams({required this.email, required this.password});

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
