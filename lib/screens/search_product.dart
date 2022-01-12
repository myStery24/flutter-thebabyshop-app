import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/models/product.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/widgets/single_product.dart';

import 'display_details.dart';

class SearchProduct extends SearchDelegate<void> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ProductProvider providerProvider = Provider.of<ProductProvider>(context);
    List<Product> searchCategory = providerProvider.searchProductList(query);

    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: searchCategory
            .map((e) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DisplayDetailsScreen(
                          image: e.imgName,
                          name: e.name,
                          price: e.price,
                          description: e.description,
                        ),
                      ),
                    );
                  },
                  child: SingleProduct(
                    image: e.imgName,
                    name: e.name,
                    price: e.price,
                  ),
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ProductProvider providerProvider = Provider.of<ProductProvider>(context);
    List<Product> searchCategory = providerProvider.searchProductList(query);
    return GridView.count(
        childAspectRatio: 0.76,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: searchCategory
            .map((e) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DisplayDetailsScreen(
                          image: e.imgName,
                          name: e.name,
                          price: e.price,
                          description: e.description,
                        ),
                      ),
                    );
                  },
                  child: SingleProduct(
                    image: e.imgName,
                    name: e.name,
                    price: e.price,
                  ),
                ))
            .toList());
  }
}
