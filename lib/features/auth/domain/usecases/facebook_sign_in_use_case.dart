import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';

class FacebookSignInUseCase extends BaseUseCase<void, NoParams>{
  final AuthRepository _authRepository;

  FacebookSignInUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _authRepository.facebookLogin(params);
  }
}