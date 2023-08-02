// ignore_for_file: prefer_final_fields

import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import '../model/product.dart';

@singleton
class LikedProducts {
  GetStorage _storage;

  LikedProducts(this._storage);
  static const _key = 'liked_products';

  List<Map<String, dynamic>> _getLikedProductsData() {
    final data = _storage.read<List<dynamic>>(_key);
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  void _saveLikedProductsData(List<Product> likedProducts) {
    final likedProductsJson =
        likedProducts.map((product) => product.toJson()).toList();
    _storage.write(_key, likedProductsJson);
  }

  void saveProduct(Product product) {
    final likedProducts = _getLikedProductsData();
    if (!likedProducts.any((p) => p['id'] == product.id)) {
      likedProducts.add(product.toJson());
      _saveLikedProductsData(
          likedProducts.map((json) => Product.fromJson(json)).toList());
    }
  }

  void removeProduct(Product product) {
    final likedProducts = _getLikedProductsData();
    likedProducts.removeWhere((p) => p['id'] == product.id);
    _saveLikedProductsData(
        likedProducts.map((json) => Product.fromJson(json)).toList());
  }

  bool isProductLiked(Product product) {
    final likedProducts = _getLikedProductsData();
    return likedProducts.any((p) => p['id'] == product.id);
  }

  List<Product> loadLikedProductsFromStorage() {
    final likedProductsData = _getLikedProductsData();
    return likedProductsData.map((json) => Product.fromJson(json)).toList();
  }
}
