import 'package:meka/features/offers/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity{
  const BannerModel({required super.imageUrl});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(imageUrl: json['image_url']);
  }
}