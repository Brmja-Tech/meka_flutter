
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase extends BaseUseCase<void, ResetPasswordParams> {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _authRepository.resetPassword(params);
  }
}