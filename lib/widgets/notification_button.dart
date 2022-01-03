import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key key}) : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  ProductProvider productProvider;

  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            actions: [
              TextButton(
                child: const Text('Clear Notification'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    productProvider.notificationList.clear();
                  });
                },
              ),

              /// Deprecated
              // FlatButton(
              //   child: const Text("Clear Notification"),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //     setState(() {
              //       productProvider.notificationList.clear();
              //     });
              //   },
              // ),
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              /// Deprecated
              // FlatButton(
              //   child: const Text("Okey"),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(productProvider.notificationList.isNotEmpty
                      ? "Your Product Is On The Way"
                      : "No Notification At This Moment"),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return Badge(
      position: const BadgePosition(end: 25, top: 8),
      badgeContent: Text(
        productProvider.getNotificationIndex.toString(),
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      badgeColor: Colors.red,
      child: IconButton(
        icon: const Icon(
          Icons.notifications_none,
          color: Colors.black,
        ),
        onPressed: () {
          myDialogBox(context);
        },
      ),
    );
  }
}
