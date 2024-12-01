import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/offers/domain/entities/banner_entity.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';

abstract class OffersRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners(NoParams noParams);

  Future<Either<Failure, List<ProductEntity>>> getProducts(PaginationParams params);

  Future<Either<Failure, List<ProductEntity>>> getOffers(PaginationParams params);

}
