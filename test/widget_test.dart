// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'package:design/di/locator.dart';
import 'package:design/model/product.dart';
import 'package:design/service/rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  List<Product> productList = []; // Create an empty list of Product objects
  setUpAll(() {
    setupDI();
  });

  test("Get products", () async {
    var restClient = getIt<RestClient>();

    var products = await restClient.getCategoryProduct("smartphones");

    productList = products.products!; // Assign the list of products

    print("${productList[2].title}");
  });
}
