import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';

class CheckoutSingleProduct extends StatefulWidget {
  final String name;
  final String image;
  final int index;
  int quentity;
  final int price;
  final bool isCount;

  CheckoutSingleProduct({
    Key key,
    @required this.isCount,
    @required this.index,
    @required this.quentity,
    @required this.image,
    @required this.name,
    @required this.price,
  }) : super(key: key);
  @override
  _CheckoutSingleProductState createState() => _CheckoutSingleProductState();
}

TextStyle myStyle = const TextStyle(fontSize: 16);
ProductProvider productProvider;

class _CheckoutSingleProductState extends State<CheckoutSingleProduct> {
  double height, width;

  Widget _buildImage() {
    return Container(
      height: height * 0.1 + 55,
      width: width * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(widget.image),
        ),
      ),
    );
  }

  Widget _buildNameAndClosePart() {
    return Container(
      height: 30,
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
            style: myStyle,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.isCount == false
                  ? productProvider.deleteCartProduct(widget.index)
                  : productProvider.deleteCheckoutProduct(widget.index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCountOrNot() {
    return Container(
      height: 35,
      // width: width * 0.2 + 20,
      // color: const Color(0xfff2f2f2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // const Text("Quantity"),
          Padding(
            padding: const EdgeInsets.all(1),
            child: widget.isCount == false
                ? Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 15.0,
                          ),
                          onTap: () {
                            setState(() {
                              if (widget.quentity > 1) {
                                widget.quentity--;
                                productProvider.updateQuantity(
                                    widget.quentity, widget.index);
                              }
                            });
                          },
                        ),
                        /*SizedBox(
                        height: 5,
                      ),*/
                        Text(
                          widget.quentity.toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 15.0,
                          ),
                          onTap: () {
                            setState(() {
                              widget.quentity++;
                              productProvider.updateQuantity(
                                  widget.quentity, widget.index);
                            });
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: width * 0.2 + 20,
                    height: 35,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          "Quantity",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.quentity.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height * 0.2,
      width: double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _buildImage(),
                SizedBox(
                  height: height * 0.1 + 50,
                  width: width * 0.6,
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildNameAndClosePart(),
                        //_buildColorAndSizePart(),
                        Text(
                          "RM ${widget.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: kSecondaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        _buildCountOrNot(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
