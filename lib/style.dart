import 'package:flutter/material.dart';

// 언더바(_)를 붙히면 다른 파일에서 접근 불가능 private
var _var1;

var theme = ThemeData(
  // Button Style 방법
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //     backgroundColor: Colors.grey
  //   )
  // ),
  // elevatedButtonTheme: ElevatedButtonThemeData(),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
    actionsIconTheme: IconThemeData(color: Colors.black)
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.red),
  ),
);