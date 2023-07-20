import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'products.g.dart';

@JsonSerializable()
class Products {
	List<Product>? products;
	int? total;
	int? skip;
	int? limit;

	Products({this.products, this.total, this.skip, this.limit});

	factory Products.fromJson(Map<String, dynamic> json) {
		return _$ProductsFromJson(json);
	}

	Map<String, dynamic> toJson() => _$ProductsToJson(this);
}
