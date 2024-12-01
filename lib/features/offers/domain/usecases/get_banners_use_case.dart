import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/offers/domain/entities/banner_entity.dart';
import 'package:meka/features/offers/domain/repositories/offers_repository.dart';

class GetBannersUseCase extends BaseUseCase<List<BannerEntity>, NoParams> {
  final OffersRepository _offersRepository;

  GetBannersUseCase(this._offersRepository);

  @override
  Future<Either<Failure, List<BannerEntity>>> call(NoParams params) {
    return _offersRepository.getBanners(params);
  }
}
