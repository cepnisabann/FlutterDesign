// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:design/base/base_widget.dart';
import 'package:design/pages/viewmodels/storepage_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../model/product.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends BaseState<StorePageViewModel, StorePage> {
  final ScrollController storepageController = PageController();
  final PageController storepageminiController = PageController();
  @override
  void initState() {
    viewModel.getProduct(0);
    viewModel.getCategories();
    // viewModel scroll listener
    storepageController.addListener(() {
      if (storepageController.position.pixels ==
          storepageController.position.maxScrollExtent) {
        viewModel.onScroll();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: viewModel.isLoading
            ? buildLoading()
            : viewModel.hasError
                ? buildError(viewModel)
                : buildView(viewModel.products, viewModel.categories, viewModel,
                    context),
      ),
    );
  }

  Widget buildError(StorePageViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            viewModel.errorMessage,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await viewModel.getProduct(30);
            },
            child: Text('Fetch data'),
          ),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget buildView(List<Product> products, List<String> categories,
      StorePageViewModel viewModel, BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tüm ürünler',
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
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight((MediaQuery.of(context).size.height * 0.09) + 15),
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
                  child: const Row(
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
                    viewModel.sortPrice();
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Sırala ",
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w400),
                      ),
                      Icon(
                        viewModel.isSortedUp
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
                  final isSelected = index == viewModel.selectedCategoryIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton(
                      onPressed: () {
                        viewModel.getCategoryProduct(categories[index]);

                        viewModel.selectedCategoryIndex = index;
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
                controller: storepageController,
                itemCount: viewModel.shownList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/productDetail',
                          arguments: products[index]);
                    },
                    child: Container(
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
                                    controller: storepageminiController,
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.hardEdge,
                                    onPageChanged: (value) {
                                      viewModel.imageindex[index] = value;
                                      viewModel.notifyListeners();
                                    },
                                    itemCount: viewModel
                                        .shownList[index].images!.length,
                                    itemBuilder: (context, index2) {
                                      return CachedNetworkImage(
                                          imageUrl: viewModel.shownList[index]
                                              .images![index2]);
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 14,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      viewModel.toggleLike(index);
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
                                          viewModel.shownList[index].isLiked ??
                                                  false
                                              ? PhosphorIcons.heart_fill
                                              : PhosphorIcons.heart_light,
                                          color: viewModel.shownList[index]
                                                      .isLiked ??
                                                  false
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
                                            "${viewModel.shownList[index].rating ?? ''} (${viewModel.shownList[index].rating! * viewModel.shownList[index].price! ~/ 3})",
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
                                      count: viewModel
                                          .shownList[index].images!.length,
                                      index: viewModel.imageindex[index],
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
                                    viewModel.shownList[index].title ??
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
                                          "%${(100 - ((viewModel.shownList[index].price!) / (viewModel.shownList[index].price! + 150) * 100)).toStringAsFixed(0)}",
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
                                              "${viewModel.currentType.format(viewModel.shownList[index].price! + 150)} TL",
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
                                              "${viewModel.currentType.format(viewModel.shownList[index].price!)} TL",
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
                    ),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
