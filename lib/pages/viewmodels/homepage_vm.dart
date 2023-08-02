import 'dart:math';

import 'package:design/base/base_view_model.dart';
import 'package:design/model/product.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../repo/favorite_repository.dart';
import '../../repo/product_repository.dart';

@injectable
class HomeViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  final FavoriteRepository _favoriteRepository;
  HomeViewModel(this._productRepository, this._favoriteRepository);
  String errorMessage = '';
  List<String> categories = [];
  List<Product> categoryProducts = [];
  List<Product> products = [];
  List<Product> searchList = [];
  int selectedButtonIndex = 0;
  List<int> imageindex = List<int>.filled(30, 0);
  int currentSliderPage = 1;
  bool isLoading = true;
  bool isLoading2 = false;
  bool isSearch = false;
  double height = 0;
  double width = 0;
  bool hasError = false;
  final TextEditingController textFieldController = TextEditingController();
  final PageController newspageController = PageController();
  final PageController storepageController = PageController();
  final PageController storepageminiController = PageController();

  final currentType = NumberFormat("#,##0.00", "tr_TR");

  List<int> myList = [
    Random().nextInt(30),
    Random().nextInt(30),
    Random().nextInt(30)
  ];

  Future<void> getProduct(int skip) async {
    try {
      searchList.length = 0;
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
      hasError = true;
      isLoading = false;
      notifyListeners();
    }
  }

  void selectButton(int index) {
    selectedButtonIndex = index;
    notifyListeners();
  }

  void onSliderPageChanged(int index) {
    currentSliderPage = index + 1;
    notifyListeners();
  }

  void onImagePageChanged(int index, value) {
    imageindex[index] = value;
    notifyListeners();
  }

  Future doSearch(String text) async {
    try {
      searchList = await _productRepository.searchProduct(text);
      isSearch = true;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  String formatPrice(int price) {
    return currentType.format(price);
  }

  void toggleLike(int index) {
    products[index].isLiked = !(products[index].isLiked ?? false);
    if (products[index].isLiked == true) {
      // Add the product to the list of liked products.
      _favoriteRepository.addFavoriteProduct(products[index]);
    } else {
      // Remove the product from the list of liked products.
      _favoriteRepository.removeFavoriteProduct(products[index]);
    }

    notifyListeners();
  }

  List<Product> favorites = [];

  void getFavorites() async {
    _favoriteRepository
        .getFavoriteProducts()
        .then((value) => favorites = value);
    if (favorites.isEmpty) {
      hasError = true;
      notifyListeners();
    }
    if (favorites.isNotEmpty) {
      notifyListeners();
    }
  }

  void detailsRoute(BuildContext context, Product product) {}
}
