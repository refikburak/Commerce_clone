import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int id;
  String? title;
  double? price;
  String? description;
  Category? category;
  List<String>? images;

  Product({
    required this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
