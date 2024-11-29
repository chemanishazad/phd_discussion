import 'package:flutter/material.dart';
import '../const/palette.dart';
import '../const/styles.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Theme with Google Fonts
ThemeData lightTheme(double fontSize) {
  return ThemeData(
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
      displayLarge: GoogleFonts.lato(
        textStyle: headingLarge(color: Palette.blackColor, fontSize: fontSize),
      ),
      displayMedium: GoogleFonts.lato(
        textStyle: headingMedium(color: Palette.blackColor, fontSize: fontSize),
      ),
      displaySmall: GoogleFonts.lato(
        textStyle: headingSmall(color: Palette.blackColor, fontSize: fontSize),
      ),
      headlineLarge: GoogleFonts.lato(
        textStyle: titleLarge(color: Palette.blackColor, fontSize: fontSize),
      ),
      headlineMedium: GoogleFonts.lato(
        textStyle: titleMedium(color: Palette.blackColor, fontSize: fontSize),
      ),
      headlineSmall: GoogleFonts.lato(
        textStyle: titleSmall(color: Palette.blackColor, fontSize: fontSize),
      ),
      titleLarge: GoogleFonts.lato(
        textStyle: bodyLarge(color: Palette.blackColor, fontSize: fontSize),
      ),
      titleMedium: GoogleFonts.lato(
        textStyle: bodyMedium(color: Palette.blackColor, fontSize: fontSize),
      ),
      titleSmall: GoogleFonts.lato(
        textStyle: bodySmall(color: Palette.blackColor, fontSize: fontSize),
      ),
      labelLarge: GoogleFonts.lato(
        textStyle:
            buttonTextStyle(color: Palette.blackColor, fontSize: fontSize),
      ),
      labelMedium: GoogleFonts.lato(
        textStyle: captionStyle(color: Palette.blackColor, fontSize: fontSize),
      ),
      labelSmall: GoogleFonts.lato(
        textStyle: overlineStyle(color: Palette.blackColor, fontSize: fontSize),
      ),
    ),
    iconTheme: iconTheme(color: Palette.themeColor),
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
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: elevatedButtonStyle(
        fontSize: fontSize,
        foregroundColor: Palette.whiteColor,
        backgroundColor: Palette.themeColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: outlinedButtonStyle(
        fontSize: fontSize,
        foregroundColor: Palette.themeColor,
        borderColor: Palette.themeColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle(
        foregroundColor: Palette.themeColor,
        fontSize: fontSize,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      BoxDecorationTheme(
        primaryDecoration: primaryBoxDecoration(color: Palette.whiteColor),
        secondaryDecoration: secondaryBoxDecoration(color: Palette.greyColor),
      ),
    ],
  );
}

// Dark Theme with Google Fonts
ThemeData darkTheme(double fontSize) {
  return ThemeData(
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
      displayLarge: GoogleFonts.lato(
        textStyle: headingLarge(color: Palette.whiteColor, fontSize: fontSize),
      ),
      displayMedium: GoogleFonts.lato(
        textStyle: headingMedium(color: Palette.whiteColor, fontSize: fontSize),
      ),
      displaySmall: GoogleFonts.lato(
        textStyle: headingSmall(color: Palette.whiteColor, fontSize: fontSize),
      ),
      headlineLarge: GoogleFonts.lato(
        textStyle: titleLarge(color: Palette.whiteColor, fontSize: fontSize),
      ),
      headlineMedium: GoogleFonts.lato(
        textStyle: titleMedium(color: Palette.whiteColor, fontSize: fontSize),
      ),
      headlineSmall: GoogleFonts.lato(
        textStyle: titleSmall(color: Palette.whiteColor, fontSize: fontSize),
      ),
      titleLarge: GoogleFonts.lato(
        textStyle: bodyLarge(color: Palette.whiteColor, fontSize: fontSize),
      ),
      titleMedium: GoogleFonts.lato(
        textStyle: bodyMedium(color: Palette.whiteColor, fontSize: fontSize),
      ),
      titleSmall: GoogleFonts.lato(
        textStyle: bodySmall(color: Palette.whiteColor, fontSize: fontSize),
      ),
      labelLarge: GoogleFonts.lato(
        textStyle:
            buttonTextStyle(color: Palette.whiteColor, fontSize: fontSize),
      ),
      labelMedium: GoogleFonts.lato(
        textStyle: captionStyle(color: Palette.whiteColor, fontSize: fontSize),
      ),
      labelSmall: GoogleFonts.lato(
        textStyle: overlineStyle(color: Palette.whiteColor, fontSize: fontSize),
      ),
    ),
    iconTheme: iconTheme(color: Palette.lightBackgroundColor),
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
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: elevatedButtonStyle(
        fontSize: fontSize,
        foregroundColor: Palette.whiteColor,
        backgroundColor: Palette.themeColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: outlinedButtonStyle(
        fontSize: fontSize,
        foregroundColor: Palette.whiteColor,
        borderColor: Palette.themeColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle(
        foregroundColor: Palette.whiteColor,
        fontSize: fontSize,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      BoxDecorationTheme(
        primaryDecoration:
            primaryBoxDecoration(color: Palette.darkBackgroundColor),
        secondaryDecoration: secondaryBoxDecoration(color: Palette.greyColor),
      ),
    ],
  );
}
