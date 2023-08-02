import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  const DetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  double findRealPrice(int originalPrice, double discountPercentage) {
    return (originalPrice * ((discountPercentage + 100) / 100));
  }

  Product get product => widget.product;
  var imageindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details "),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        imageindex = value;
                      });
                    },
                    itemCount: product.images?.length ?? 1,
                    itemBuilder: (context, index) {
                      final image = product.images?[index] ?? product.thumbnail;
                      imageindex = index;
                      return CachedNetworkImage(
                        imageUrl: image ?? "",
                        fit: BoxFit
                            .scaleDown, // Adjust the image content mode as needed
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 14),
                      child: CarouselIndicator(
                        width: 6,
                        color: Colors.grey,
                        count: product.images!.length,
                        index: imageindex,
                        activeColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.brand ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (product.discountPercentage != null)
                    Row(
                      children: [
                        Text(
                          "${findRealPrice(product.price!, product.discountPercentage!).toStringAsFixed(2)} TL",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.black,
                            decorationThickness: 2.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          " ${product.discountPercentage}% Discount",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Text(
                    "${product.price} TL",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Rating: ${product.rating}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "In Stock: ${product.stock}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Category: ${product.category}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
  import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  const DetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  double findRealPrice(int originalPrice, double discountPercentage) {
    return (originalPrice * ((discountPercentage + 100) / 100));
  }

  var imageindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details "),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        imageindex = value;
                      });
                    },
                    itemCount: widget.product.images?.length ?? 1,
                    itemBuilder: (context, index) {
                      final image = widget.product.images?[index] ??
                          widget.product.thumbnail;
                      imageindex = index;
                      return CachedNetworkImage(
                        imageUrl: image ?? "",
                        fit: BoxFit
                            .scaleDown, // Adjust the image content mode as needed
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 14),
                      child: CarouselIndicator(
                        width: 6,
                        color: Colors.grey,
                        count: widget.product.images!.length,
                        index: imageindex,
                        activeColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.brand ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.product.discountPercentage != null)
                    Row(
                      children: [
                        Text(
                          "${findRealPrice(widget.product.price!, widget.product.discountPercentage!).toStringAsFixed(2)} TL",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.black,
                            decorationThickness: 2.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          " ${widget.product.discountPercentage}% Discount",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.product.price} TL",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Rating: ${widget.product.rating}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "In Stock: ${widget.product.stock}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Category: ${widget.product.category}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
  int? id;
  String? title;
  String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;
  bool? isLiked;
  */
  */