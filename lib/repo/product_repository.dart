import 'package:design/service/rest_client.dart';
import 'package:injectable/injectable.dart';

import '../service/likedproducts.dart';
import '../model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProduct(int skip);
  Future<List<String>> getCategories();
  Future<List<Product>> getCategoryProduct(String category);
  Future<List<Product>> searchProduct(String query);
}

@Singleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final RestClient _restClient;
  final LikedProducts _likedProducts;
  ProductRepositoryImpl(this._restClient, this._likedProducts);

  @override
  Future<List<Product>> getProduct(int skip) async {
    final productsList = await _restClient.getProduct(skip);
    final likedProducts = _likedProducts.loadLikedProductsFromStorage();
    final productList = productsList.products!;
    // Update the isLiked property for each product based on whether it's in the liked list
    for (var product in productList) {
      product.isLiked = likedProducts.any((p) => p.id == product.id);
    }

    return productList;
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

  @override
  Future<List<Product>> searchProduct(String query) async {
    final response = await _restClient.searchProduct(query);
    var responselist = response.products!;
    return responselist;
  }
}

//possible crash
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
