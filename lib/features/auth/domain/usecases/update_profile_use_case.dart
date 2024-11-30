import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase extends BaseUseCase<UserEntity, RegisterParams> {
  final AuthRepository _authRepository;

  UpdateProfileUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _authRepository.updateProfile(params);
  }
}
