import 'package:json_annotation/json_annotation.dart';
import 'package:koctas/data/model/product/category.dart';
import 'package:koctas/data/model/product/product.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/products")
  Future<List<Product>> getProduct();

  @GET("/products/:id")
  Future<Product> getProductDetail();

  @GET("/categories/")
  Future<List<Category>> getCategories();
}
