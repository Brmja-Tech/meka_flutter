import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String image;
  final String price;
  final String? discount;

  const ProductEntity(
      {required this.id,
      required this.title,
      required this.image,
      required this.price,
       this.discount});

  @override
  List<Object?> get props => [id, title, image, price, discount];
}
