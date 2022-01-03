import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/widgets/checkout_single_product.dart';
import 'package:the_baby_shop_app/widgets/notification_button.dart';

import 'checkout.dart';
import 'home.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

ProductProvider productProvider;

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(bottom: 15),
        child: ElevatedButton(
          child: const Text('Continue'),
          style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              elevation: 1,
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              )),
          onPressed: () {
            //productProvider.addNotification("Notification");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => CheckOut(),
                //builder: (ctx) => CartScreen(),
              ),
            );
          },
        ),

        /// Deprecated
        // child: RaisedButton(
        //   color: kPrimaryColor,
        //   child: const Text("Continue",
        //     style: TextStyle(fontSize: 18, color: Colors.white),
        //   ),
        //   onPressed: () {
        //     //productProvider.addNotification("Notification");
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (ctx) => CheckOut(),
        //         //builder: (ctx) => CartScreen(),
        //       ),
        //     );
        //   },
        // ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.black),
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
          },
        ),
        actions: const <Widget>[
          NotificationButton(),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: productProvider.getCheckOutModelListLength,
                itemBuilder: (ctx, index) => CheckoutSingleProduct(
                  isCount: false,
                  index: index,
                  image: productProvider.getCheckOutModelList[index].image,
                  name: productProvider.getCheckOutModelList[index].name,
                  price: productProvider.getCheckOutModelList[index].price,
                  quentity:
                      productProvider.getCheckOutModelList[index].quentity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
