import 'package:get_it/get_it.dart';
import 'package:meka/features/offers/data/datasources/offers_data_source.dart';
import 'package:meka/features/offers/data/repositories/offers_repository_impl.dart';
import 'package:meka/features/offers/domain/usecases/get_banners_use_case.dart';
import 'package:meka/features/offers/domain/usecases/get_offers_use_case.dart';
import 'package:meka/features/offers/domain/usecases/get_products_use_case.dart';
import 'package:meka/features/offers/presentation/blocs/offers/offers_bloc.dart';
import 'package:meka/features/offers/presentation/blocs/product/product_bloc.dart';

class OffersServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton(() => OffersDataSourceImpl(sl()));
    sl.registerLazySingleton(() => OffersRepositoryImpl(sl()));
    sl.registerFactory(() => GetBannersUseCase(sl()));
    sl.registerFactory(() => GetOffersUseCase(sl()));
    sl.registerFactory(() => GetProductsUseCase(sl()));
    sl.registerFactory(() => OffersBloc(sl(), sl()));
    sl.registerFactory(() => ProductBloc(sl()));
  }
}
