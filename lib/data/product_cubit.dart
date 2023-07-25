import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../repo/product_repository.dart';
import 'package:equatable/equatable.dart';

part "product_state.dart";

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  ProductCubit(this._productRepository) : super(ProductInitial());

  Future<void> getProduct(int skip) async {
    try {
      emit(ProductLoading());

      final products = await _productRepository.getProduct(skip);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getCategories(int skip) async {
    try {
      emit(CategoryLoading());

      final categories = await _productRepository.getCategories();
      final products = await _productRepository
          .getProduct(skip); // Update the skip value here if needed

      emit(CategoryLoaded(products, categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> getCategoryProduct(String category) async {
    try {
      emit(ProductLoading());

      final products = await _productRepository.getCategoryProduct(category);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
