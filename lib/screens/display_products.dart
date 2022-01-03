import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/models/product.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/screens/display_details.dart';
import 'package:the_baby_shop_app/widgets/notification_button.dart';
import 'package:the_baby_shop_app/widgets/single_product.dart';

import 'home.dart';
import 'search_product.dart';

class DisplayProducts extends StatelessWidget {
  ProductProvider productProvider;
  final List<Product> data;
  final String name;

  DisplayProducts({Key key, @required this.name, @required this.data})
      : super(key: key);

  Widget _buildTopName() {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMyGridView(context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      // height: 600,
      height: 800,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        childAspectRatio: orientation == Orientation.portrait ? 0.8 : 0.9,
        scrollDirection: Axis.vertical,
        children: data
            .map(
              (e) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
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
                  price: e.price,
                  image: e.imgName,
                  name: e.name,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSearchBar(context) {
    return IconButton(
      icon: const Icon(
        Icons.search,
        color: Colors.black,
      ),
      onPressed: () {
        productProvider.getSearchList(list: data);
        showSearch(context: context, delegate: SearchProduct());
      },
    );
  }

  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          name,
          style: const TextStyle(color: Colors.black),
        ),
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
        actions: <Widget>[
          _buildSearchBar(context),
          const NotificationButton(),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            //_buildTopName(),
            const SizedBox(
              height: 10,
            ),
            _buildMyGridView(context),
          ],
        ),
      ),
    );
  }
}
