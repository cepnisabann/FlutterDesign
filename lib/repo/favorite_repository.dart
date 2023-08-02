import 'package:injectable/injectable.dart';

import '../service/likedproducts.dart';
import '../model/product.dart';

abstract class FavoriteRepository {
  Future<List<Product>> getFavoriteProducts();
  Future<void> addFavoriteProduct(Product product);
  Future<void> removeFavoriteProduct(Product product);
}

@Singleton(as: FavoriteRepository)
class FavoriteRepositoryImpl implements FavoriteRepository {
  final LikedProducts _likedProducts;

  FavoriteRepositoryImpl(this._likedProducts);

  @override
  Future<List<Product>> getFavoriteProducts() async {
    final productList = _likedProducts.loadLikedProductsFromStorage();
    for (var product in productList) {
      product.isLiked = _likedProducts.isProductLiked(product);
    }
    return productList;
  }

  @override
  Future<void> addFavoriteProduct(Product product) async {
    _likedProducts.saveProduct(product); // Call instance method on the instance
  }

  @override
  Future<void> removeFavoriteProduct(Product product) async {
    _likedProducts
        .removeProduct(product); // Call instance method on the instance
  }
}
