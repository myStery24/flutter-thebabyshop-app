import 'dart:ui';

import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

/// Color
const kPrimaryColor = Color(0xFFfdb4be);
const kSecondaryColor = Colors.blue;
const kLinearGradientBlue = [Color(0xff374ABE), Color(0xff64B6FF)];
const kLinearGradientPink = [Color(0xffFFB9B9), Color(0xffFF7979)];
const kBGColor = Color(0xfffafafa);

// Text color
const kTextBlack = Colors.black;
const kTextGrey = Colors.grey;
const kTextPurple = Color(0xff9b96d6);

const Color primary = Color(0xff000000);
const Color medium = Color(0xff515151);
const Color secondary = Color(0xffffffff);
const Color accent = Color(0xFFEA9F5A);

const Color success = Color(0xff44c93a);
const Color danger = Color(0xffff4657);
const Color info = Color(0xff5bc0de);
const Color warning = Color(0xfffeba06);

const Color bgAppbarBlack = Color(0xff232528);
const Color bgAppbarWhite = Color(0xffffffff);

const Color bgAppbarGradientStart = Color(0xFF191C20);
const Color bgAppbarGradientEnd = Color(0xFF29313E);

const Color bgButtonBlack = Color(0xFF17181A);
const Color bgButtonBlue = Color(0xFF3B66BE);
const Color bgButtonWhite = Color(0xffffffff);

const Color black = Color(0xff000000);
const Color white = Color(0xffffffff);
const Color blue = Color(0xff0D47A1);
const Color grey = Color(0xffbdbdbd);
const Color lineWhite = Color(0xffececec);
const Color lineGrey = Color(0xffbdbdbd);
const Color lineTextGrey = Color(0xff9E9E9E);

const Color darkModeButton = Color(0xff2F3641);
const Color lightModeButton = Color(0xff000000);
const Color darkBgCircle = Color(0xff2F3641);
