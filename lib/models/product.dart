import 'package:flutter/material.dart';

class Product {
  final String name;
  final String imgName;
  final int price;
  final String description;

  Product({
    @required this.imgName,
    @required this.name,
    @required this.price,
    @required this.description,
  });
}