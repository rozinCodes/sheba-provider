import 'package:flutter/material.dart';
import 'dart:math';

class MyColor {
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBackground = Color(0xFFF5F9FC);
  static const Color colorGrey = Color(0xFFF5F6F7);
  static const Color colorBlue = Color(0xFF283593);
  static const Color colorBlack = Color(0xFF000000);
  static const Color colorGreen = Color(0xFF567F5F);
  static const Color textColor = Color(0xFF424242);

  static const Color primaryColor = Color(0xFF808080);
  static const Color primaryAssentColor = Color(0xFF808080);
  static const Color primaryDarkColor = Color(0xFF808080);
  static const Color errorColor = Color(0xFF808080);

  static List _colors = [
    Colors.red,
    Colors.green,
    Colors.greenAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.indigo,
    Colors.orange,
    Colors.deepOrange,
    Colors.teal,
    Colors.purple,
    Colors.deepPurple,
    Colors.brown
  ];

  static Color randomColor() {
    return _colors[new Random().nextInt(_colors.length)];
  }
}
