import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/models/cart_model.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/widgets/checkout_single_product.dart';
import 'package:the_baby_shop_app/widgets/custom_button.dart';
import 'package:the_baby_shop_app/widgets/notification_button.dart';

import 'home.dart';

/// Error in this screen
class CheckOut extends StatefulWidget {
  const CheckOut({Key key}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextStyle myStyle = const TextStyle(
    fontSize: 15,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String
      address; //= "Jalan Bentara, Taman Ungku Tun Aminah, Johor Bahru, Johor";

  ProductProvider productProvider;

  Widget _buildBottomSingleDetail(
      {@required String startName, @required String endName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          startName,
          style: myStyle,
        ),
        Text(
          endName,
          style: myStyle,
        ),
      ],
    );
  }

  //User user;
  double total;
  List<CartModel> myList;

  Widget _buildButton() {
    return Column(
        children: productProvider.userModelList.map((e) {
      address = e.userAddress;
      return Container(
        height: 50,
        child: CustomButton(
          color: kPrimaryColor,
          name: "Buy",
          onPressed: () {
            productProvider.addNotification("Notification");
            if (productProvider.getCheckOutModelList.isNotEmpty) {
              FirebaseFirestore.instance.collection("Order").add({
                "Product": productProvider.getCheckOutModelList
                    .map((c) => {
                          "ProductName": c.name,
                          "ProductPrice": c.price,
                          "ProductQuantity": c.quentity,
                          "ProductImage": c.image,
                        })
                    .toList(),
                "TotalPrice": total.toStringAsFixed(2),
                "UserName": e.userName,
                "UserEmail": e.userEmail,
                "UserNumber": e.userPhoneNumber,
                "UserAddress": e.userAddress,
                "UserId": e.uid,
              });
              setState(() {
                myList.clear();
                _showMyDialog();
              });
              //productProvider.addNotification("Notification");
            } else {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text("No Item Yet"),
                ),
              );
            }
          },
        ),
      );
    }).toList());
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Completed'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text('Your order has been received!'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Thank you!',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                // print('Okay');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    myList = productProvider.checkOutModelList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //user = FirebaseAuth.instance.currentUser;
    double subTotal = 0;
    double discount = 10;
    double discountRinggit;
    double shipping = 5;

    productProvider = Provider.of<ProductProvider>(context);
    productProvider.getCheckOutModelList.forEach((element) {
      subTotal += element.price * element.quentity;
    });

    discountRinggit = discount / 100 * subTotal;
    total = subTotal + shipping - discountRinggit;
    if (productProvider.checkOutModelList.isEmpty) {
      total = 0.0;
      discount = 0.0;
      shipping = 0.0;
    }

    //productProvider.getUserData();
    //UserModel user = productProvider.getUserModel;
    //address = user.userAddress;

    Future<bool> redirectTo() async {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Home();
      }));
      return true;
    }

    return WillPopScope(
      onWillPop: redirectTo,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Checkout", style: TextStyle(color: Colors.black)),
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
        bottomNavigationBar: Container(
          height: 65,
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildButton(),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: myList.isNotEmpty
                    ? Column(
                        children: <Widget>[
                          Row(
                            children: const [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Address: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            address,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              //fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                          )
                        ],
                      )
                    : const Text(
                        "No item yet!",
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
              ),
              Container(
                  height: 50,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: myList.isNotEmpty
                      ? Column(
                          children: <Widget>[
                            Row(
                              children: const [
                                Icon(
                                  Icons.credit_card,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Payment: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Cash On Delivery",
                                //softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                //maxLines: 1,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                            )
                          ],
                        )
                      : const Text("")),
              Expanded(
                flex: 2,
                child: Container(
                  child: ListView.builder(
                    itemCount: myList.length,
                    itemBuilder: (ctx, myIndex) {
                      return CheckoutSingleProduct(
                        isCount: true,
                        index: myIndex,
                        image: myList[myIndex].image,
                        name: myList[myIndex].name,
                        price: myList[myIndex].price,
                        quentity: myList[myIndex].quentity,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildBottomSingleDetail(
                        startName: "Subtotal",
                        endName: "RM ${subTotal.toStringAsFixed(2)}",
                      ),
                      _buildBottomSingleDetail(
                        startName: "Discount",
                        endName: "${discount.toStringAsFixed(2)}%",
                      ),
                      _buildBottomSingleDetail(
                        startName: "Shipping",
                        endName: "RM ${shipping.toStringAsFixed(2)}",
                      ),
                      _buildBottomSingleDetail(
                        startName: "Total",
                        endName: "RM ${total.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
