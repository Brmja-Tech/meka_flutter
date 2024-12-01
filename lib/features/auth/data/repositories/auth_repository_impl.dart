import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';

import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/entities/register_response_entity.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Either<Failure, void>> appleLogin(NoParams noParams) {
    return _authDataSource.appleLogin(noParams);
  }

  @override
  Future<Either<Failure, void>> facebookLogin(NoParams noParams) {
    return _authDataSource.facebookLogin(noParams);
  }

  @override
  Future<Either<Failure, void>> forgetPassword(ForgetPasswordParams params) {
    return _authDataSource.forgetPassword(params);
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(NoParams params) {
    return _authDataSource.getUserProfile(params);
  }

  @override
  Future<Either<Failure, void>> googleLogin(NoParams noParams) {
    return _authDataSource.googleLogin(noParams);
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) {
    return _authDataSource.login(params);
  }

  @override
  Future<Either<Failure, void>> logout(NoParams params) {
    return _authDataSource.logout(params);
  }

  @override
  Future<Either<Failure, UserEntity>> oTPVerify(OTPVerifyParams params) {
    return _authDataSource.oTPVerify(params);
  }

  @override
  Future<Either<Failure, RegisterResponseEntity>> register(RegisterParams params) {
    return _authDataSource.register(params);
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params) {
    return _authDataSource.resetPassword(params);
  }

  @override
  Future<Either<Failure, void>> sendOTP(SendOTPParams params) {
    return _authDataSource.sendOTP(params);
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(RegisterParams params) {
    return _authDataSource.updateProfile(params);
  }
}
