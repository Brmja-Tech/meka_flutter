import 'package:equatable/equatable.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';

enum ProductStateStatus { initial, loading, success, failure }

extension ProductStateStatusX on ProductState {
  bool get isInitial => status == ProductStateStatus.initial;

  bool get isLoading => status == ProductStateStatus.loading;

  bool get isSuccess => status == ProductStateStatus.success;

  bool get isError => status == ProductStateStatus.failure;
}

class ProductState extends Equatable {
  final ProductStateStatus status;
  final String? errorMessage;
  final List<ProductEntity> products;

  const ProductState({
    this.status = ProductStateStatus.initial,
    this.errorMessage,
    this.products = const [],
  });

  ProductState copyWith({
    ProductStateStatus? status,
    String? errorMessage,
    List<ProductEntity>? products,
  }) {
    return ProductState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, products];
}
