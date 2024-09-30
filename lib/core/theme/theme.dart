import 'package:flutter/material.dart';
import '../const/palette.dart';
import '../const/styles.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Palette.themeColor,
  colorScheme: const ColorScheme.light(
    primary: Palette.themeColor,
    secondary: Palette.themeColor,
    surface: Palette.lightBackgroundColor,
  ),
  scaffoldBackgroundColor: Palette.whiteColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    displayLarge: displayLarge(color: Palette.blackColor),
    displayMedium: displayMedium(color: Palette.blackColor),
    displaySmall: displaySmall(color: Palette.blackColor),
    headlineLarge: headlineLarge(color: Palette.blackColor),
    headlineMedium: headlineMedium(color: Palette.blackColor),
    headlineSmall: headlineSmall(color: Palette.blackColor),
    titleLarge: titleLarge(color: Palette.blackColor),
    titleMedium: titleMedium(color: Palette.blackColor),
    titleSmall: titleSmall(color: Palette.blackColor),
    labelLarge: primaryButton(color: Palette.blackColorLight),
    labelMedium: caption(color: Palette.blackColorLight),
    labelSmall: overline(color: Palette.blackColorLight),
  ),
  iconTheme: primaryIconThemeData(Palette.iconColor),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.lightGreyColor),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.themeColor),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    filled: true,
    fillColor: Palette.lightGreyColor,
    contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    hintStyle: subtitle2(color: Palette.blackColorLight),
    labelStyle: titleMedium(color: Palette.blackColor),
    errorStyle: titleSmall(color: Colors.red),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: primaryElevatedButtonStyle(Palette.whiteColor, Palette.themeColor),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: primaryOutlinedButtonStyle(Palette.themeColor, Palette.themeColor),
  ),
  textButtonTheme: TextButtonThemeData(
    style: primaryTextButtonStyle(Palette.themeColor),
  ),
  extensions: <ThemeExtension<dynamic>>[
    BoxDecorationTheme(
      primaryBoxDecoration: primaryBoxDecoration(Palette.whiteColor),
      secondaryBoxDecoration: secondaryBoxDecoration(Palette.greyColor),
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Palette.themeColor,
  colorScheme: const ColorScheme.dark(
    primary: Palette.themeColor,
    secondary: Palette.themeColor,
    surface: Palette.darkBackgroundColor,
  ),
  scaffoldBackgroundColor: Palette.darkBackgroundColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
  textTheme: TextTheme(
    displayLarge: displayLarge(color: Palette.whiteColor),
    displayMedium: displayMedium(color: Palette.whiteColor),
    displaySmall: displaySmall(color: Palette.whiteColor),
    headlineLarge: headlineLarge(color: Palette.whiteColor),
    headlineMedium: headlineMedium(color: Palette.whiteColor),
    headlineSmall: headlineSmall(color: Palette.whiteColor),
    titleLarge: titleLarge(color: Palette.whiteColor),
    titleMedium: titleMedium(color: Palette.whiteColor),
    titleSmall: titleSmall(color: Palette.whiteColor),
    labelLarge: primaryButton(color: Palette.whiteColor),
    labelMedium: caption(color: Palette.greyColor),
    labelSmall: overline(color: Palette.greyColor),
  ),
  iconTheme: primaryIconThemeData(Palette.iconColor),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.greyColor),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.themeColor),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    filled: true,
    fillColor: Palette.greyColor,
    contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    hintStyle: subtitle2(color: Palette.greyColor),
    labelStyle: titleMedium(color: Palette.whiteColor),
    errorStyle: titleSmall(color: Colors.red),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: primaryElevatedButtonStyle(Palette.whiteColor, Palette.themeColor),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: primaryOutlinedButtonStyle(Palette.whiteColor, Palette.themeColor),
  ),
  textButtonTheme: TextButtonThemeData(
    style: primaryTextButtonStyle(Palette.whiteColor),
  ),
  extensions: <ThemeExtension<dynamic>>[
    BoxDecorationTheme(
      primaryBoxDecoration: primaryBoxDecoration(Palette.darkBackgroundColor),
      secondaryBoxDecoration: secondaryBoxDecoration(Palette.greyColor),
    ),
  ],
);
