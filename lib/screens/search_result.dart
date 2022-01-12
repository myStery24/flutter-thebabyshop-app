import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/models/product.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/widgets/single_product.dart';

import 'display_details.dart';
import 'home.dart';

class SearchResult extends StatelessWidget {

  ProductProvider productProvider;
  final List<Product> data;
  String letter;

  SearchResult({
    Key key,
    @required this.data,
    @required this.letter,
  }) : super(key: key);

  Widget _buildMyGridView(context, searchCategory) {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        height: 600,
        child: GridView.count(
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
                .toList()));
  }

  @override
  Widget build(BuildContext context) {

    productProvider = Provider.of<ProductProvider>(context);
    List<Product> searchCategory = productProvider.searchProductList(letter);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Result', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const Home(),
                ),
              );
            }),
        /*actions: <Widget>[
          _buildSearchBar(context),
          //NotificationButton(),
        ],*/
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
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
                  .toList())),
    );
  }
}
