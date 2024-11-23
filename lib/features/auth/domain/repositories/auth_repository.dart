import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(LoginParams params);
  Future<Either<Failure, void>> register(RegisterParams params);
  Future<Either<Failure, void>> logout(NoParams noParams);
  Future<Either<Failure, void>> googleSignIn(LoginParams params);
}
