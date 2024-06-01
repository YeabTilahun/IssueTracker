import 'package:flutter/material.dart';

var appTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14.0),
    labelLarge: TextStyle(color: Colors.white),
  ),
  cardColor: Colors.grey[200],
);
