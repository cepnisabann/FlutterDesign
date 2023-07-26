import 'dart:math';

import 'package:design/base/base_view_model.dart';
import 'package:design/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../repo/product_repository.dart';

@injectable
class HomeViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  HomeViewModel(this._productRepository);
  String errorMessage = '';
  List<String> categories = [];
  List<Product> categoryProducts = [];
  List<Product> products = [];
  int selectedButtonIndex = 0;
  List<int> imageindex = List<int>.filled(30, 0);
  int currentSliderPage = 1;
  bool isLoading = true;
  bool isLoading2 = false;
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

  void doSearch(String text) {
    // ignore: avoid_print
    print('Search text: $text');
    // Perform your search operation or any other logic here
  }

  String formatPrice(int price) {
    return currentType.format(price);
  }

  void toggleLike(int index) {
    products[index].isLiked = !(products[index].isLiked ?? false);
    notifyListeners();
  }

  // Additional logic and methods for the Home page can be added here
}
