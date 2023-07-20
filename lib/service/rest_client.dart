import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/products.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://dummyjson.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/products")
  Future<Products> getProduct(@Query("skip") int skip);

  @GET("/products/categories")
  Future<List<String>> getCategories();

  @GET("/products/category/{category}")
  Future<Products> getCategoryProduct(@Path("category") String category);
}
