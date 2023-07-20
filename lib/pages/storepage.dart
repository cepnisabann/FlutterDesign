// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_local_variable, unused_import

import 'dart:math';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:design/model/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:route_map/route_map.dart';
import '../di/locator.dart';
import '../model/product.dart';
import '../service/rest_client.dart';
import '../service/route_map.dart';
import '../service/route_map.routes.dart';
import '../widgets/bottom_navigation_bar.dart';

@RouteMap(name: "/home")
class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

int selectedCategoryIndex = 0;

final ScrollController _storepageController = PageController();
final PageController _storepageminiController = PageController();
int scrollLength = 0;
int selectedButtonIndex = 0;
bool isFetchingData = false;
bool isLoading = true;
List<int> imageindex = List<int>.filled(30, 0);
List<Product> categoryProducts = [];
List<Product> sortedList = [];
List<Product> shownList = [];
List<Product> productList = []; // Create an empty list of Product objects
Products products = [] as Products;
final currentType = NumberFormat("#,##0.00", "tr_TR");
List<String> categories = [];
Future<Products> fetchProduct(int productId) async {
  var restClient = getIt<RestClient>();
  var fetchedProducts = await restClient.getProduct(productId);
  var newProducts = fetchedProducts.products!;

  if (productId > 20) {
    productList.addAll(newProducts);
    imageindex = List<int>.filled(30 + productId, 0);
  } else {
    categories = await restClient.getCategories();
    productList = newProducts;
    shownList = productList;
  }

  isLoading = false;
  return fetchedProducts;
}

Future<Products> fetchCategoryProduct(String categoryname) async {
  var restClient = getIt<RestClient>();
  var fetchedCategoryProducts =
      await restClient.getCategoryProduct(categoryname);
  var newcategoryProducts = fetchedCategoryProducts.products!;
  categoryProducts = newcategoryProducts;

  return fetchedCategoryProducts;
}

class _StorePageState extends State<StorePage> {
  Future<void> _refreshGridView() async {
    if (isFetchingData) return; // Prevent multiple simultaneous refresh calls
    try {
      setState(() {
        isFetchingData =
            true; // Set the flag to indicate that data is being fetched
      });
      // Fetch new data from the API
      var newProducts = await fetchProduct(scrollLength + shownList.length);
      // Add the new products to the existing productList
      shownList.addAll(newProducts.products!);
    } catch (e) {
      print('Error fetching new data: $e');
    } finally {
      setState(() {
        isFetchingData = false; // Reset the flag after fetching is complete
      });
    }
  }

  void _onScroll() {
    if (_storepageController.position.pixels ==
        _storepageController.position.maxScrollExtent) {
      scrollLength += 30;
      // Call _refreshGridView to update the productList
      _refreshGridView().then((_) {
        setState(() {}); // Force a rebuild to show the new products
      });
      print("${productList.length}");
    }
  }

  @override
  void initState() {
    super.initState();

    scrollLength = 0;
    fetchProduct(scrollLength).then((value) {
      products = value;
      setState(() {
        if (scrollLength == 0) {
          categories.insert(0, "Tümü");
        }
        isLoading = false;
      });
    });

    _storepageController.addListener(_onScroll);
  }

  bool isSortedUp = false;

  final List<Color> colorList = [Colors.red, Colors.yellow, Colors.green];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'StorePage',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: height * 0.11,
          backgroundColor: Colors.orange.shade800,
          foregroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Koltuk ve Kanepeler',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '100 ürün',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight((height * 0.09) + 15),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 0.8),
                ),
              ),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle menu item selection here
                      print("Selected: $value");
                    },
                    itemBuilder: (context) {
                      return categories.map((category) {
                        return PopupMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList();
                    },
                    child: Row(
                      children: [
                        Text("Filtrele "),
                        Icon(CupertinoIcons.slider_horizontal_3),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 0.3, // Adjust the thickness of the divider
                    height: 40, // Adjust the height of the divider
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSortedUp = !isSortedUp;
                        if (isSortedUp) {
                          sortedList = List.from(productList);
                          sortedList.sort(
                              (a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
                          shownList = sortedList;
                        } else {
                          shownList = shownList.reversed.toList();
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Sırala ",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400),
                        ),
                        Icon(
                          isSortedUp
                              ? CupertinoIcons.sort_up
                              : CupertinoIcons.sort_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  // You can add more buttons here
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(),
        body: Container(
          color: Colors.white,
          child: Container(
            color: Colors.white38,
            child: Column(children: [
              Expanded(
                flex: 6,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedCategoryIndex;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: TextButton(
                        onPressed: () {
                          if (index != 0) {
                            fetchCategoryProduct(categories[index]).then(
                              (value) {
                                shownList = categoryProducts;
                                setState(() {
                                  selectedCategoryIndex = index;
                                  print(
                                      "Clicked category: ${categories[index]}");
                                });
                              },
                            );
                          } else {
                            shownList = productList;
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange.shade400
                                  : Colors.grey.shade200,
                              width: 1.5,
                            ),
                            color: isSelected
                                ? Colors.orange.shade400
                                : Colors.grey.shade200,
                          ),
                          child: Text(
                            "${categories[index].characters.first.toUpperCase()}${categories[index].substring(1)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isSelected ? Colors.white : Colors.black38,
                              // Add any additional styles you want for the text.
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 33,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.65,
                    crossAxisCount: 2,
                  ),
                  controller: _storepageController,
                  itemCount: shownList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Set the border color
                          width: 0.3, // Set the border width
                        ),
                        borderRadius: BorderRadius.circular(
                            0), // Optionally, add rounded corners
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 1, right: 1),
                                  child: PageView.builder(
                                    controller: _storepageminiController,
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.hardEdge,
                                    onPageChanged: (value) {
                                      setState(() {
                                        imageindex[index] = value;
                                      });
                                    },
                                    itemCount: shownList[index].images!.length,
                                    itemBuilder: (context, index2) {
                                      return CachedNetworkImage(
                                          imageUrl:
                                              shownList[index].images![index2]);
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 14,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle the heart color when clicked
                                        shownList[index]
                                            .isLiked = !(shownList[index]
                                                .isLiked ??
                                            false); // Check if isLiked is not null before toggling
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 1,
                                          color: Colors
                                              .grey, // Change color as desired
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          shownList[index].isLiked ?? false
                                              ? PhosphorIcons.heart_fill
                                              : PhosphorIcons.heart_light,
                                          color:
                                              shownList[index].isLiked ?? false
                                                  ? Colors.red
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            // bottom store image texts
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        Icon(PhosphorIcons.star_fill,
                                            color: Colors.orange, size: 10),
                                        Text(
                                            "${shownList[index].rating ?? ''} (${(shownList[index].rating! * shownList[index].price! / 3).toInt()})",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CarouselIndicator(
                                      width: 6,
                                      color: Colors.grey,
                                      count: productList[index].images!.length,
                                      index: imageindex[index],
                                      activeColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, bottom: 8, top: 2),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    shownList[index].title ??
                                        '', // Check if title is not null before displaying
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 32,
                                      width: 32,
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Colors.red.shade800,
                                        child: Text(
                                          "%${(100 - ((shownList[index].price!) / (shownList[index].price! + 150) * 100)).toStringAsFixed(0)}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      // Wrap the Column with Expanded
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Align text to the start of the column
                                          children: [
                                            Text(
                                              "${currentType.format(shownList[index].price! + 150)} TL",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.black,
                                                decorationThickness: 2.0,
                                              ),
                                            ),
                                            Text(
                                              "${currentType.format(shownList[index].price!)} TL",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ]),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: GlobalBottomNavigationBar(
              initialIndex: 1,
            )),
      ),
    );
  }
}
