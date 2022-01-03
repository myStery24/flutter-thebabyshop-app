import 'package:flutter/material.dart';

import 'screens/home.dart';

class TheBabyShopApp extends StatefulWidget {
  const TheBabyShopApp({key}) : super(key: key);

  @override
  _TheBabyShopAppState createState() => _TheBabyShopAppState();
}

class _TheBabyShopAppState extends State<TheBabyShopApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Home(),
    );
  }
}
