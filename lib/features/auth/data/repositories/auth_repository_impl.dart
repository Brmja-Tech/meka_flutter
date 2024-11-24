import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';

import 'package:meka/features/auth/data/datasources/auth_data_source.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Either<Failure, void>> login(LoginParams params) {
    return _authDataSource.login(params);
  }

  @override
  Future<Either<Failure, void>> logout(NoParams noParams) {
    return _authDataSource.logout(noParams);
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams params) {
    return _authDataSource.register(params);
  }

  @override
  Future<Either<Failure, void>> googleSignIn(LoginParams params) {
    return _authDataSource.googleLogin(params);
  }
  @override
  Future<Either<Failure, void>> facebookSignIn(LoginParams params) {
    return _authDataSource.facebookLogin(params);
  }
}
