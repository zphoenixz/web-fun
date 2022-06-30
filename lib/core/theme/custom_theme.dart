import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: Constants.mainFont,
      appBarTheme: const AppBarTheme(
        color: Constants.appBarColor,
      ),
      tabBarTheme: const TabBarTheme(
        indicator: BoxDecoration(
          color: Constants.mediumBlackColor,
        ),
        labelStyle: TextStyle(
          fontSize: Constants.bodyFont,
          fontFamily: Constants.mainFont,
        ),
        unselectedLabelColor: Constants.mediumBlackColor,
        unselectedLabelStyle: TextStyle(
          fontSize: Constants.bodyFont,
          fontFamily: Constants.mainFont,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: Constants.titleFont,
          fontFamily: Constants.mainFont,
          color: Constants.mediumBlackColor,
        ),
        displayMedium: TextStyle(
          fontSize: Constants.bodyFont,
          fontFamily: Constants.mainFont,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontSize: Constants.subtitleFont,
          fontFamily: Constants.mainFont,
          color: Constants.mediumBlackColor,
        ),
        titleLarge: TextStyle(
          fontSize: Constants.titleFont,
          fontFamily: Constants.mainFont,
          color: Constants.mediumBlackColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          fontSize: Constants.contentFont,
          fontFamily: Constants.mainFont,
          color: Constants.mediumBlackColor,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
