import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';
import 'package:meka/features/offers/domain/usecases/get_products_use_case.dart';
import 'package:meka/features/offers/presentation/blocs/product/product_state.dart';

class ProductBloc extends Cubit<ProductState> {
  ProductBloc(this._getProductsUseCase) : super(const ProductState());
  final GetProductsUseCase _getProductsUseCase;

  List<ProductEntity> products = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialOffers() async {
    emit(state.copyWith(status: ProductStateStatus.loading));
    products.clear();
    currentPage = 1;
    hasMoreData = true;
    await getOffers();
  }

  Future<void> getOffers() async {
    if (!hasMoreData || isLoadingMore) return;
    final result = await _getProductsUseCase(
        PaginationParams(page: currentPage, limit: pageSize));
    result.fold(
        (l) => emit(ProductState(
            errorMessage: l.message, status: ProductStateStatus.failure)), (r) {
      products.addAll(r);
      if (r.length < pageSize) {
        hasMoreData = false;
      } else {
        currentPage++;
      }
      isLoadingMore = false;
      emit(ProductState(products: r, status: ProductStateStatus.success));
    });
  }
}
