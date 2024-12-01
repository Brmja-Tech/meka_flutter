import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';
import 'package:meka/features/offers/domain/repositories/offers_repository.dart';

class GetOffersUseCase
    extends BaseUseCase<List<ProductEntity>, PaginationParams> {
  final OffersRepository _offersRepository;

  GetOffersUseCase(this._offersRepository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(PaginationParams params) {
    return _offersRepository.getOffers(params);
  }
}
