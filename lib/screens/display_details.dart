import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/screens/cart_screen.dart';
import 'package:the_baby_shop_app/widgets/custom_button.dart';
import 'package:the_baby_shop_app/widgets/notification_button.dart';

import 'home.dart';

class DisplayDetailsScreen extends StatefulWidget {
  final String image;
  final String name;
  final String description;
  final int price;
  const DisplayDetailsScreen(
      {Key key,
      @required this.image,
      @required this.name,
      @required this.description,
      @required this.price})
      : super(key: key);

  @override
  _DisplayDetailsScreenState createState() => _DisplayDetailsScreenState();
}

class _DisplayDetailsScreenState extends State<DisplayDetailsScreen> {
  int count = 1;
  ProductProvider productProvider;

  Widget _buildColorProduct({Color color}) {
    return Container(
      height: 40,
      width: 40,
      color: color,
    );
  }

  final TextStyle myStyle = const TextStyle(
    fontSize: 18,
  );

  Widget _buildImage() {
    return Center(
      child: Container(
        width: 380,
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(13),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(widget.image),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameToDescriptionPart() {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.name, style: myStyle),
              Text(
                "RM ${widget.price.toString()}",
                style: const TextStyle(
                    color: kSecondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text("Description", style: myStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      // height: 170,
      height: 120,
      child: Wrap(
        children: <Widget>[
          Text(
            //"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",
            widget.description,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Text(
          "Quantity",
          style: myStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
              ),
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPart() {
    return Container(
      height: 60,
      child: CustomButton(
        name: "Add To Cart",
        color: kPrimaryColor,
        onPressed: () {
          productProvider.getCheckOutData(
            image: widget.image,
            name: widget.name,
            price: widget.price,
            quentity: count,
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // builder: (ctx) => CheckOut(),
              builder: (ctx) => const CartScreen(),
            ),
          );
        },
      ),
    );
  }

  Future<bool> redirectTo() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Home();
    }));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return WillPopScope(
      onWillPop: redirectTo,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Detail",
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
        body: ListView(
          children: <Widget>[
            _buildImage(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildNameToDescriptionPart(),
                  _buildDescription(),
                  //_buildSizePart(),
                  //_buildColorPart(),
                  _buildQuantityPart(),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildButtonPart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
