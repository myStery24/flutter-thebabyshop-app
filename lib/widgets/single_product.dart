import 'package:flutter/material.dart';
import 'package:the_baby_shop_app/constants/colors.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  final int price;
  final String name;
  const SingleProduct(
      {Key key,
      @required this.image,
      @required this.name,
      @required this.price})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width, height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Card(
      child: Container(
        height: height * 0.3,
        width: width * 0.2 * 2 + 10,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(image),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kSecondaryColor),
                  ),
                  Text(
                    "RM ${price.toString()}",
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
