part of 'product_cubit.dart';

@immutable
abstract class ProductState extends Equatable {}

class ProductInitial extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {
  ProductLoading();

  @override
  List<Object?> get props => [];
}

class ProductLoaded extends ProductState {
  List<Product> products;
  ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends ProductState {
  @override
  List<Object?> get props => [];
}

class CategoryLoading extends ProductState {
  CategoryLoading();

  @override
  List<Object?> get props => [];
  List<Object?> get props2 => [];
}

class CategoryLoaded extends ProductState {
  List<Product> products;
  List<String> categories;
  CategoryLoaded(this.products, this.categories);

  @override
  List<Object?> get props => [products];
  List<Object?> get props2 => [categories];
}

class CategoryError extends ProductState {
  final String message;
  CategoryError(this.message);

  @override
  List<Object?> get props => [];
  List<Object?> get props2 => [];
}
