import 'package:design/base/base_view_model.dart';
import 'package:injectable/injectable.dart';

import '../../model/product.dart';
import '../../repo/product_repository.dart';

@injectable
class DetailsViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  DetailsViewModel(this._productRepository);
  List<Product> products = [];
  List<String> categories = [];
  List<Product> categoryProducts = [];
  bool isLoading = false;
  bool isLoading2 = false;
  String errorMessage = '';

  Future<void> getProduct(int skip) async {
    try {
      isLoading = true;
      notifyListeners();
      final products = await _productRepository.getProduct(skip);
      this.products = products;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    try {
      isLoading2 = true;
      notifyListeners();

      final categories = await _productRepository.getCategories();
      this.categories = categories;
      isLoading2 = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading2 = false;
      notifyListeners();
    }
  }

  Future<void> getCategoryProduct(String category) async {
    try {
      isLoading = true;
      notifyListeners();

      final products = await _productRepository.getCategoryProduct(category);
      categoryProducts = products;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
