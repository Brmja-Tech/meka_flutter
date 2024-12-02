import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';
import 'package:meka/features/offers/domain/usecases/get_banners_use_case.dart';
import 'package:meka/features/offers/domain/usecases/get_offers_use_case.dart';
import 'package:meka/features/offers/presentation/blocs/offers/offers_state.dart';

class OffersBloc extends Cubit<OffersState> {
  OffersBloc(this._getBannersUseCase, this._getOffersUseCase)
      : super(const OffersState()) {
    getBanners();
    getOffers();
  }
  final GetBannersUseCase _getBannersUseCase;
  final GetOffersUseCase _getOffersUseCase;

  Future<void> getBanners() async {
    final result = await _getBannersUseCase(const NoParams());

    result.fold(
        (l) => emit(OffersState(
            errorMessage: l.message, status: OffersStateStatus.failure)),
        (r) =>
            emit(OffersState(banners: r, status: OffersStateStatus.success)));
  }
  @override
  Future<void> close() {
    // Do nothing or add custom logic if needed
    super.close();
    return Future.value();
  }
  List<ProductEntity> offers = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialOffers() async {
    emit(state.copyWith(status: OffersStateStatus.loading));
    offers.clear();
    currentPage = 1;
    hasMoreData = true;
    await getOffers();
  }
  Future<void> getOffers() async {
    if (!hasMoreData || isLoadingMore) return;
    final result = await _getOffersUseCase(
        PaginationParams(page: currentPage, limit: pageSize));
    result.fold(
        (l) => emit(OffersState(
            errorMessage: l.message, status: OffersStateStatus.failure)), (r) {
      offers.addAll(r);
      if (r.length < pageSize) {
        hasMoreData = false;
      } else {
        currentPage++;
      }
      isLoadingMore = false;
      emit(OffersState(offers: r, status: OffersStateStatus.success));
    });
  }
}
