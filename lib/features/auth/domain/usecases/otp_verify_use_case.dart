
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';

class OtpVerifyUseCase extends BaseUseCase<void, OTPVerifyParams> {
  final AuthRepository _authRepository;

  OtpVerifyUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(OTPVerifyParams params) {
    return _authRepository.oTPVerify(params);
  }
}