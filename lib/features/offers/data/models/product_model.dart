import 'package:meka/features/offers/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel(
      {required super.id,
      required super.productId,
      required super.title,
      required super.image,
      required super.price,
      super.discount});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['offer_id'],
      productId: json['product_id'],
      title: json['title'],
      image: json['image'] ??
          'https://www.hoistcrane.com/wp-content/uploads/2017/05/Header-stock-photo-portrait-of-construction-worker-on-building-site-303643508-e1495218037891.jpg',
      price: json['price'],
      discount: json['discount'],
    );
  }
}
