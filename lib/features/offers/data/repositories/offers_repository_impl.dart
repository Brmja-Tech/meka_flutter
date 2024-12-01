import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/offers/data/datasources/offers_data_source.dart';
import 'package:meka/features/offers/domain/entities/banner_entity.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';

import '../../domain/repositories/offers_repository.dart';

class OffersRepositoryImpl implements OffersRepository {
  final OffersDataSource _offersDataSource;

  OffersRepositoryImpl(this._offersDataSource);

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners(NoParams noParams) {
    return _offersDataSource.getBanners(noParams);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getOffers(PaginationParams params) {
    return _offersDataSource.getOffers(params);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(PaginationParams params) {
    return _offersDataSource.getProducts(params);
  }
}
