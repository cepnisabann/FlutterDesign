import 'package:cached_network_image/cached_network_image.dart';
import 'package:design/pages/viewmodels/favoritespage_vm.dart';
import 'package:flutter/material.dart';

import '../base/base_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends BaseState<FavoritesViewModel, FavoritesPage> {
  @override
  void initState() {
    viewModel.getFavorites().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        backgroundColor: Colors.orange.shade800,
        title: const Center(child: Text("Favoriler")),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              viewModel.getFavorites();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: viewModel.isLoading
            ? buildLoading()
            : viewModel.hasError
                ? buildError(viewModel)
                : buildView(context, viewModel),
      ),
    );
  }
}

Widget buildError(FavoritesViewModel viewModel) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          viewModel.errorMessage,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            viewModel.getFavorites();
          },
          child: const Text('Favorileri Yenile'),
        ),
      ],
    ),
  );
}

Widget buildLoading() {
  return const Center(
    child: CircularProgressIndicator.adaptive(),
  );
}

Widget buildView(BuildContext context, FavoritesViewModel viewModel) {
  return ListView.builder(
    itemCount: viewModel.favorites.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/productDetail',
              arguments: viewModel.favorites[index]);
        },
        child: Card(
          // List tile with cached image and title and price
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 20), // Increase the vertical padding
            leading: SizedBox(
              width: 120, // Set the desired width for the leading widget
              child: CachedNetworkImage(
                imageUrl: viewModel.favorites[index].images![0],
                fit:
                    BoxFit.scaleDown, // Adjust the image content mode as needed
              ),
            ),
            title: Text(viewModel.favorites[index].title!),
            subtitle: Text("${viewModel.favorites[index].price} TL"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                viewModel.removeFavorite(viewModel.favorites[index]);
              },
            ),
          ),
        ),
      );
    },
  );
}
