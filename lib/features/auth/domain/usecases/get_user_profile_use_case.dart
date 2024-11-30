
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase extends BaseUseCase<UserEntity, NoParams> {
  final AuthRepository _authRepository;

  GetProfileUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _authRepository.getUserProfile(params);
  }
}