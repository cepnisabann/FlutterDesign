// ignore_for_file: avoid_print

import 'package:design/base/base_view_model.dart';
import 'package:design/model/product.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../repo/product_repository.dart';

@injectable
class StorePageViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  StorePageViewModel(this._productRepository);
  bool hasError = false;

  int selectedCategoryIndex = 0;
  var height = 0.0;
  var width = 0.0;
  int scrollLength = 0;
  int selectedButtonIndex = 0;
  bool isFetchingData = false;
  bool isLoading = false;
  List<int> imageindex = List<int>.filled(30, 0);
  List<Product> categoryProducts = [];
  List<Product> sortedList = [];
  List<Product> shownList = [];
  List<Product> products = [];
  bool isSortedUp = false;
  String errorMessage = '';
  final currentType = NumberFormat("#,##0.00", "tr_TR");
  List<String> categories = [];

  Future<List<Product>> fetchProduct(int skip) async {
    var products = await _productRepository.getProduct(skip);
    return products;
  }

  Future<void> getProduct(int skip) async {
    try {
      isLoading = true;
      notifyListeners();
      products = await _productRepository.getProduct(skip);
      shownList = products;
      print("products: $products");
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void getCategoryProduct(String category) async {
    try {
      notifyListeners();
      products = await _productRepository.getCategoryProduct(category);
      print("products: $products");
      shownList = products;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      categories = await _productRepository.getCategories();
      print("categories: $categories");
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

  Future<void> refreshgridview() async {
    if (isFetchingData) {
      return;
    }
    try {
      isFetchingData = true;
      notifyListeners();
      var newProductList = await _productRepository.getProduct(scrollLength);
      shownList.addAll(newProductList);
      imageindex = List<int>.filled(30 + scrollLength, 0);

      print("shownList: $shownList");
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      isFetchingData = false;
      notifyListeners();
    }
  }

  void onScroll() {
    scrollLength += 30;
    refreshgridview().then((value) {
      notifyListeners();
    });
  }

  void toggleLike(int index) {
    shownList[index].isLiked = !(shownList[index].isLiked ?? false);
    notifyListeners();
  }

  void sortPrice() {
    sortedList = shownList;

    if (isSortedUp) {
      sortedList.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));

      notifyListeners();
    } else {
      sortedList.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    }
    isSortedUp = !isSortedUp;
    shownList = sortedList;
    notifyListeners();
  }
}
