// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:design/base/base_widget.dart';
import 'package:design/pages/viewmodels/homepage_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../model/product.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomeViewModel, HomePage> {
  @override
  void initState() {
    viewModel.getProduct(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 40, top: 14),
          child: SvgPicture.asset(
            'assets/logo.svg',
            width: MediaQuery.of(context).size.width * 0.35,
            colorFilter: ColorFilter.mode(
              Colors.orange.shade800,
              BlendMode.srcIn,
            ),
          ),
        ),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(PhosphorIcons.list, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight((MediaQuery.of(context).size.height * 0.09) + 15),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: SizedBox(
              height: (MediaQuery.of(context).size.height * 0.05) + 16,
              child: TextField(
                controller: viewModel.textFieldController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  hintText: 'Ürün, kategori veya marka ara...',
                  prefixIcon: IconButton(
                    onPressed: () =>
                        viewModel.doSearch(viewModel.textFieldController.text),
                    icon: const Icon(PhosphorIcons.magnifying_glass_light),
                  ),
                  suffixIcon: const Icon(PhosphorIcons.barcode_light),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Adjust vertical alignment
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: viewModel.isLoading
            ? buildLoading()
            : viewModel.hasError
                ? buildError(viewModel)
                : buildView(viewModel.products, context, viewModel),
      ),
    );
  }

  Widget buildError(HomeViewModel viewModel) {
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

  Widget buildView(
      List<Product> products, BuildContext contextm, HomeViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(contextm).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: viewModel.selectedButtonIndex == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {
                        viewModel.selectButton(0);
                      },
                      child: Row(
                        children: [
                          Text(
                            "Bugüne Özel",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: viewModel.selectedButtonIndex == 0
                                  ? Colors.orange.shade800
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: viewModel.selectedButtonIndex == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {
                        viewModel.selectButton(1);
                      },
                      child: Text(
                        "Kampanyalar",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: viewModel.selectedButtonIndex == 1
                              ? Colors.orange.shade800
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: viewModel.selectedButtonIndex == 2
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {
                        viewModel.selectButton(2);
                      },
                      child: Text(
                        "Ayrıcalıklar",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: viewModel.selectedButtonIndex == 2
                              ? Colors.orange.shade800
                              : Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(
            height: MediaQuery.of(contextm).size.height * 0.37,
            child: Stack(
              children: [
                PageView.builder(
                  controller: viewModel.newspageController,
                  itemCount: 3,
                  onPageChanged: (index) {
                    viewModel.onSliderPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle tap if needed
                            },
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                child: CachedNetworkImage(
                                    imageUrl: products[viewModel.myList[index]]
                                        .images![0])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxLines: 1,
                                    '${products[viewModel.myList[index]].description}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${products[viewModel.myList[index]].title}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  left: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.symmetric(
                        vertical: BorderSide(width: 1, color: Colors.grey),
                        horizontal: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 5, top: 5),
                      child: Text(
                        '  ${viewModel.currentSliderPage}/3  ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 34,
                  child: GestureDetector(
                    onTap: () {
                      print("object");
                      // Handle "+" button tap if needed
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.shade800,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        PhosphorIcons.arrow_right_light,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Container(
              color: Colors.white38,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Widget 1",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: TextButton(
                        onPressed: () {
                          // Add your functionality here for the TextButton
                        },
                        child: Text(
                          "Tümü >",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors
                                .orange.shade400, // Change color as desired
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(contextm).size.height * 0.3,
            child: Container(
                color: Colors.white38,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  controller: viewModel.storepageController,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller:
                                        viewModel.storepageminiController,
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.hardEdge,
                                    onPageChanged: (value) {
                                      viewModel.onImagePageChanged(
                                          index, value);
                                    },
                                    itemCount: products[index].images!.length,
                                    itemBuilder: (context, index2) {
                                      return CachedNetworkImage(
                                          imageUrl:
                                              products[index].images![index2]);
                                    },
                                  ),
                                  Positioned(
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        viewModel.toggleLike(
                                            index); // Check if isLiked is not null before toggling
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
                                            viewModel.products[index].isLiked ??
                                                    false
                                                ? PhosphorIcons.heart_fill
                                                : PhosphorIcons.heart_light,
                                            color: viewModel.products[index]
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
                                              "${products[index].rating ?? ''} (${products[index].rating! * products[index].price! ~/ 3})",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ))
                                        ],
                                      ),
                                    ),
                                    CarouselIndicator(
                                      width: 6,
                                      color: Colors.grey,
                                      count: products[index].images!.length,
                                      index: viewModel.imageindex[index],
                                      activeColor: Colors.black,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 8, top: 2),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      products[index].title ??
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.green,
                                          child: Text(
                                            "%${(100 - ((products[index].price!) / (products[index].price! + 150) * 100)).toStringAsFixed(0)}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${viewModel.formatPrice(products[index].price! + 150)} TL",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.black,
                                                decorationThickness: 2.0,
                                              ),
                                            ),
                                            Text(
                                              "${viewModel.formatPrice(products[index].price!)} TL",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
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
                )),
          ),
        ],
      ),
    );
  }
}
