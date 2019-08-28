import 'package:flutter/material.dart';

ThemeData costumTheme = ThemeData(
  fontFamily: 'NanumGothic',
  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    title: TextStyle(
      fontSize: 36.0,
    ),
    body1: TextStyle(
      fontSize: 14.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.black, fontSize: 20.0),
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  cardTheme: CardTheme(elevation: 10.0),
  backgroundColor: Colors.black,
);
