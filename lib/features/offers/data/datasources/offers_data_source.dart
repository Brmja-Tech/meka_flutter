import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/features/offers/data/models/banner_model.dart';
import 'package:meka/features/offers/data/models/product_model.dart';
import 'package:meka/features/offers/domain/entities/banner_entity.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';

abstract class OffersDataSource {
  Future<Either<Failure, List<BannerEntity>>> getBanners(NoParams noParams);

  Future<Either<Failure, List<ProductEntity>>> getProducts(
      PaginationParams params);

  Future<Either<Failure, List<ProductEntity>>> getOffers(
      PaginationParams params);
}

class OffersDataSourceImpl implements OffersDataSource {
  final ApiConsumer _apiConsumer;

  OffersDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners(
      NoParams noParams) async {
    final result = await _apiConsumer.get(EndPoints.getBanners);
    return result.fold((l) {
      return Left(l);
    },
        (r) {
          final List<BannerEntity> banners =
          r['data'].map((e) => BannerModel.fromJson(e)).toList();

          return Right(banners);
        });
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      PaginationParams params) async {
    final result = await _apiConsumer.get(EndPoints.getProducts,
        queryParameters: params.toJson());
    return result.fold((l) => Left(l), (r) {
      final List<ProductEntity> products =
          r['data'].map((e) => ProductModel.fromJson(e)).toList();
      return Right(products);
    });
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getOffers(
      PaginationParams params) async {
    final result = await _apiConsumer.get(EndPoints.getOffers,
        queryParameters: params.toJson());
    return result.fold((l) => Left(l),
        (r) {
          final List<ProductEntity> products =
          r['data'].map((e) => ProductModel.fromJson(e)).toList();

          return Right(products);
        });
  }
}
