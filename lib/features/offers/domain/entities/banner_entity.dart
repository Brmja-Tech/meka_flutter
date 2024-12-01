import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String imageUrl;

  const BannerEntity({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}
