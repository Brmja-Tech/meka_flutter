import 'package:equatable/equatable.dart';
import 'package:meka/features/offers/domain/entities/banner_entity.dart';
import 'package:meka/features/offers/domain/entities/product_entity.dart';

enum OffersStateStatus { initial, loading, success, failure }

extension OffersStateStatusX on OffersState {
  bool get isInitial => status == OffersStateStatus.initial;

  bool get isLoading => status == OffersStateStatus.loading;

  bool get isSuccess => status == OffersStateStatus.success;

  bool get isError => status == OffersStateStatus.failure;
}

class OffersState extends Equatable {
  final OffersStateStatus status;
  final String? errorMessage;
  final List<ProductEntity> offers;
  final List<BannerEntity> banners;

  const OffersState({
    this.status = OffersStateStatus.initial,
    this.errorMessage,
    this.offers = const <ProductEntity>[],
    this.banners = const <BannerEntity>[],
  });

  OffersState copyWith({
    OffersStateStatus? status,
    String? errorMessage,
    List<ProductEntity>? offers,
    List<BannerEntity>? banners,
  }) {
    return OffersState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      errorMessage: errorMessage ?? this.errorMessage,
      offers: offers ?? this.offers,
    );
  }

  @override
  List<Object?> get props => [status, offers,errorMessage,banners];
}
