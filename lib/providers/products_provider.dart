import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:the_baby_shop_app/models/cart_model.dart';
import 'package:the_baby_shop_app/models/product.dart';
import 'package:the_baby_shop_app/models/user_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> boys = [];
  Product boysData;

  List<Product> girls = [];
  Product girlsData;

  List<Product> features = [];
  Product featuresData;

  List<CartModel> checkOutModelList = [];
  CartModel checkOutModel;

  List<UserModel> userModelList = [];
  UserModel userModel;

  Future<void> getUserData() async {
    List<UserModel> newList = [];
    User currentUser = FirebaseAuth.instance.currentUser;
    //String uid = '0214568';
    QuerySnapshot userSnapShot =
        await FirebaseFirestore.instance.collection("users").get();
    userSnapShot.docs.forEach(
      (element) {
        if (currentUser.uid == element["uid"]) {
          userModel = UserModel(
            uid: element["uid"],
            userName: element["name"],
            userEmail: element["email"],
            userAddress: element["address"],
            userImage: element["image"],
            userPhoneNumber: element["number"],
          );
          newList.add(userModel);
        }
        // print("userModel = ");
        // print(userModel);
        userModelList = newList;
      },
    );
  }

  List<UserModel> get getUserModelList {
    return userModelList;
  }

  UserModel get getUserModel {
    return userModel;
  }

  Future<void> getBoysData() async {
    List<Product> newList = [];
    QuerySnapshot boysSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("NLWTeQLbGVhLrDLdgqQx")
        .collection("boys")
        .get();
    boysSnapShot.docs.forEach(
      (element) {
        boysData = Product(
            imgName: element["imgName"],
            name: element["name"],
            price: element["price"],
            description: element["description"]);
        newList.add(boysData);
      },
    );
    boys = newList;
    notifyListeners();
  }

  List<Product> get getBoysList {
    return boys;
  }

  Future<void> getGirlsData() async {
    List<Product> newList = [];
    QuerySnapshot girlsSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("NLWTeQLbGVhLrDLdgqQx")
        .collection("girls")
        .get();
    girlsSnapShot.docs.forEach(
      (element) {
        girlsData = Product(
            imgName: element["imgName"],
            name: element["name"],
            price: element["price"],
            description: element["description"]);
        newList.add(girlsData);
      },
    );
    girls = newList;
    //print('girls product = ${girls.length}');
    notifyListeners();
  }

  List<Product> get getGirlsList {
    //print('get girls product = ${girls}');
    return girls;
  }

  Future<void> getFeaturesData() async {
    List<Product> newList = [];
    QuerySnapshot featuresSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("NLWTeQLbGVhLrDLdgqQx")
        .collection("features")
        .get();
    featuresSnapShot.docs.forEach(
      (element) {
        featuresData = Product(
            imgName: element["imgName"],
            name: element["name"],
            price: element["price"],
            description: element["description"]);
        newList.add(featuresData);
      },
    );
    features = newList;
    //print('features product = ${features.length}');
    notifyListeners();
  }

  List<Product> get getFeaturesList {
    //print('get girls product = ${features}');
    return features;
  }

  void getCheckOutData({
    @required int quentity,
    @required int price,
    @required String name,
    @required String image,
  }) {
    checkOutModel = CartModel(
      price: price,
      name: name,
      image: image,
      quentity: quentity,
    );
    checkOutModelList.add(checkOutModel);
  }

  void updateQuantity(int quantity, int index) {
    checkOutModelList[index].quentity = quantity;
  }

  List<CartModel> get getCheckOutModelList {
    //print("checkOutModelList =");
    //print(checkOutModelList);
    return List.from(checkOutModelList);
    //return checkOutModelList;
  }

  int get getCheckOutModelListLength {
    return checkOutModelList.length;
  }

  void deleteCartProduct(int index) {
    checkOutModelList.removeAt(index);
    notifyListeners();
  }

  void deleteCheckoutProduct(int index) {
    checkOutModelList.removeAt(index);
    notifyListeners();
  }

  void clearCheckoutProduct() {
    checkOutModelList.clear();
    notifyListeners();
  }

  List<Product> searchList;
  void getSearchList({@required List<Product> list}) {
    searchList = list;
  }

  List<Product> searchProductList(String query) {
    List<Product> searchProduct = searchList.where((element) {
      return element.name.toUpperCase().contains(query) ||
          element.name.toLowerCase().contains(query);
    }).toList();
    return searchProduct;
  }

  List<String> notificationList = [];

  void addNotification(String notification) {
    notificationList.add(notification);
  }

  int get getNotificationIndex {
    return notificationList.length;
  }

  get getNotificationList {
    return notificationList;
  }

/*List<Product> searchList;
  void getSearchList({@required List<Product> list}) {
    searchList = list;
  }

  List<Product> searchCategoryList(String query) {
    List<Product> searchShirt = searchList.where((element) {
      return element.name.toUpperCase().contains(query) ||
          element.name.toLowerCase().contains(query);
    }).toList();
    return searchShirt;
  }*/
}
