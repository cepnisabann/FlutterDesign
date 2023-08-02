import 'package:design/model/product.dart';
import 'package:injectable/injectable.dart';

import '../../base/base_view_model.dart';
import '../../repo/favorite_repository.dart';
import '../../repo/product_repository.dart';

@injectable
class FavoritesViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  final FavoriteRepository _favoriteRepository;
  FavoritesViewModel(this._productRepository, this._favoriteRepository);
  List<Product> products = [];
  String errorMessage = '';
  bool isLoading = true;
  bool hasError = false;

  List<Product> favorites = [];
  Future<void> getProduct(int skip) async {
    try {
      isLoading = true;
      notifyListeners();
      products = await _productRepository.getProduct(skip);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future getFavorites() async {
    notifyListeners();
    await _favoriteRepository
        .getFavoriteProducts()
        .then((value) => favorites = value);
    if (favorites.isEmpty) {
      hasError = true;
      errorMessage = "Favori ürün bulunamadı";
      isLoading = false;
      notifyListeners();
    } else if (favorites.isNotEmpty) {
      isLoading = false;

      hasError = false;
      notifyListeners();
    }
    return;
  }

  void removeFavorite(Product product) {
    _favoriteRepository.removeFavoriteProduct(product);
    favorites.remove(product);
    notifyListeners();
  }
}
