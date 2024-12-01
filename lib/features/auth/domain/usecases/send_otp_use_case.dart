
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/entities/register_response_entity.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';

class SendOTPUseCase extends BaseUseCase<RegisterResponseEntity, SendOTPParams> {
  final AuthRepository _authRepository;

  SendOTPUseCase(this._authRepository);

  @override
  Future<Either<Failure, RegisterResponseEntity>> call(SendOTPParams params) {
    return _authRepository.sendOTP(params);
  }
}