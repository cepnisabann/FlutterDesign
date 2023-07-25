import 'package:design/service/rest_client.dart';
import 'package:injectable/injectable.dart';

import '../model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProduct(int skip);
  Future<List<String>> getCategories();
  Future<List<Product>> getCategoryProduct(String category);
}

@Singleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final RestClient _restClient;
  ProductRepositoryImpl(this._restClient);

  @override
  Future<List<Product>> getProduct(int skip) async {
    final response = await _restClient.getProduct(skip);
    var responselist = response.products!;
    return responselist;
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await _restClient.getCategories();
    return response;
  }

  @override
  Future<List<Product>> getCategoryProduct(String category) async {
    final response = await _restClient.getCategoryProduct(category);
    var responselist = response.products!;
    return responselist;
  }
}

//possible crash
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
