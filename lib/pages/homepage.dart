// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:math';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:design/model/products.dart';
import 'package:design/pages/storepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
// import 'package:route_map/route_map.dart';
import '../di/locator.dart';
// import '../model/navitemmodel.dart';
import '../model/product.dart';
import '../service/rest_client.dart';
import '../widgets/bottom_navigation_bar.dart';
// import '../service/route_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import '../service/route_map.routes.dart';

// @RouteMap(name: "/")
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// int currentIndex = 0;
// final List<NavItemModel> _items = [
//   NavItemModel(
//       icon: FontAwesomeIcons.qrcode,
//       label: 'Scanner',
//       route: RouteMaps.root,
//       key: GlobalKey<NavigatorState>()),
//   NavItemModel(
//       icon: Icons.widgets,
//       label: 'History',
//       route: RouteMaps.storePage,
//       key: GlobalKey<NavigatorState>()),
// NavItemModel(
//     icon: FontAwesomeIcons.cartShopping,
//     label: 'My Code',
//     route: RouteMaps.myCode,
//     key: GlobalKey<NavigatorState>()),
// NavItemModel(
//     icon: FontAwesomeIcons.user,
//     label: 'Settings',
//     route: RouteMaps.settings,
//     key: GlobalKey<NavigatorState>()),
// ];

int selectedButtonIndex = 0;
bool isLoading = true;
List<int> imageindex = List<int>.filled(30, 0);
List<Product> productList = []; // Create an empty list of Product objects
Products products = [] as Products;
final currentType = NumberFormat("#,##0.00", "tr_TR");
Future<Products> fetchProduct(int productId) async {
  var restClient = getIt<RestClient>();

  var products = await restClient.getProduct(30);
  productList = products.products!; // Assign the list of products
  isLoading = false;
  return restClient.getProduct(productId);
}

// Widget get content => TabSwitchingView(
//     currentTabIndex: currentIndex,
//     tabCount: _items.length,
//     tabBuilder: (c, index) => Navigator(
//         key: _items[index].key,
//         initialRoute: _items[index].route,
//         onUnknownRoute: (settings) => MaterialPageRoute(
//             builder: (_) => Scaffold(
//                   appBar: AppBar(title: const Text('unknown')),
//                 )),
//         onGenerateRoute: onGenerateRoute));

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    setupDI();
    super.initState();
    fetchProduct(30).then(
      (value) {
        products = value;
        setState(() {});
      },
    );
  }

  List<int> myList = [
    Random().nextInt(30),
    Random().nextInt(30),
    Random().nextInt(30)
  ];
  int currentSliderPage = 1;
  final TextEditingController _textFieldController = TextEditingController();
  final PageController _newspageController = PageController();
  final PageController _storepageController = PageController();
  final PageController _storepageminiController = PageController();

  final List<Color> colorList = [Colors.red, Colors.yellow, Colors.green];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width;

    return MaterialApp(
      // initialRoute: RouteMaps.root,
      // onGenerateRoute: onGenerateRoute,
      title: 'Homepage',
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.12,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(left: 40, top: 14),
            child: SvgPicture.asset(
              'lib/assets/logo.svg',
              width: width * 0.35,
              color: Colors.orange.shade800,
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
            preferredSize: Size.fromHeight((height * 0.09) + 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: SizedBox(
                height: (height * 0.05) + 16,
                child: TextField(
                  controller: _textFieldController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    hintText: 'Ürün, kategori veya marka ara...',
                    prefixIcon: IconButton(
                      onPressed: () => doSearch(_textFieldController.text),
                      icon: const Icon(PhosphorIcons.magnifying_glass_light),
                    ),
                    suffixIcon: const Icon(PhosphorIcons.barcode_light),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0), // Adjust vertical alignment
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(),
        body: SingleChildScrollView(
          child: Visibility(
            visible: !isLoading,
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: selectedButtonIndex == 0
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedButtonIndex = 0;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Bugüne Özel",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: selectedButtonIndex == 0
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
                              color: selectedButtonIndex == 1
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedButtonIndex = 1;
                              });
                            },
                            child: Text(
                              "Kampanyalar",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: selectedButtonIndex == 1
                                    ? Colors.orange.shade800
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: selectedButtonIndex == 2
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedButtonIndex = 2;
                              });
                            },
                            child: Text(
                              "Ayrıcalıklar",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: selectedButtonIndex == 2
                                    ? Colors.orange.shade800
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.37,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _newspageController,
                        itemCount: 3,
                        onPageChanged: (index) {
                          setState(() {
                            currentSliderPage = index + 1;
                          });
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
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.27,
                                      child: CachedNetworkImage(
                                          imageUrl: productList[myList[index]]
                                              .images![0])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          maxLines: 1,
                                          '${productList[myList[index]].description}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${productList[myList[index]].title}',
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
                              vertical:
                                  BorderSide(width: 1, color: Colors.grey),
                              horizontal:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 5, top: 5),
                            child: Text(
                              '  $currentSliderPage/3  ',
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StorePage(),
                                  ),
                                );
                                // Add your functionality here for the TextButton
                              },
                              child: Text(
                                "Tümü >",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange
                                      .shade400, // Change color as desired
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                      color: Colors.white38,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                        ),
                        controller: _storepageController,
                        itemCount: productList.length,
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
                                          controller: _storepageminiController,
                                          scrollDirection: Axis.horizontal,
                                          clipBehavior: Clip.hardEdge,
                                          onPageChanged: (value) {
                                            setState(() {
                                              imageindex[index] = value;
                                            });
                                          },
                                          itemCount:
                                              productList[index].images!.length,
                                          itemBuilder: (context, index2) {
                                            return CachedNetworkImage(
                                                imageUrl: productList[index]
                                                    .images![index2]);
                                          },
                                        ),
                                        Positioned(
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // Toggle the heart color when clicked
                                                productList[index]
                                                    .isLiked = !(productList[
                                                            index]
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
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Icon(
                                                  productList[index].isLiked ??
                                                          false
                                                      ? PhosphorIcons.heart_fill
                                                      : PhosphorIcons
                                                          .heart_light,
                                                  color: productList[index]
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
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Row(
                                              children: [
                                                Icon(PhosphorIcons.star_fill,
                                                    color: Colors.orange,
                                                    size: 10),
                                                Text(
                                                    "${productList[index].rating ?? ''} (${Random().nextInt(1000)})",
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
                                            count: productList[index]
                                                .images!
                                                .length,
                                            index: imageindex[index],
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
                                            productList[index].title ??
                                                '', // Check if title is not null before displaying
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 8),
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
                                                  "%${(100 - ((productList[index].price!) / (productList[index].price! + 150) * 100)).toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${currentType.format(productList[index].price! + 150)} TL",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          Colors.black,
                                                      decorationThickness: 2.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${currentType.format(productList[index].price!)} TL",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: PageView.builder(
                    controller:
                        _storepageController, // Provide a PageController if needed
                    itemCount: 10, // Number of items/pages
                    onPageChanged: (int index) {
                      // Handle page change event
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.red,
                        // Build your widget for each page
                        // Customize it based on the current index or data
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: currentIndex,
        //   onTap: (i) {
        //     currentIndex = i;
        //     setState(() {});
        //   },
        //   items: _items
        //       .map((e) => BottomNavigationBarItem(
        //             icon: Icon(e.icon),
        //             label: e.label,
        //           ))
        //       .toList(),
        // ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: GlobalBottomNavigationBar(
              initialIndex: 0,
            )),
      ),
    );
  }

  void doSearch(String text) {
    print('Search text: $text');
    // Perform your search operation or any other logic here
  }
}
