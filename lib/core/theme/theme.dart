import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../const/palette.dart';
import '../const/styles.dart';

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
      backgroundColor: Palette.whiteColor,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
          textStyle:
              headingLarge(color: Palette.blackColor, fontSize: fontSize)),
      displayMedium: GoogleFonts.poppins(
          textStyle:
              headingMedium(color: Palette.blackColor, fontSize: fontSize - 2)),
      displaySmall: GoogleFonts.poppins(
          textStyle:
              headingSmall(color: Palette.blackColor, fontSize: fontSize - 4)),
      titleLarge: GoogleFonts.poppins(
          textStyle: titleLarge(color: Palette.blackColor, fontSize: fontSize)),
      titleMedium: GoogleFonts.poppins(
          textStyle:
              titleMedium(color: Palette.blackColor, fontSize: fontSize - 2)),
      titleSmall: GoogleFonts.poppins(
          textStyle:
              titleSmall(color: Palette.blackColor, fontSize: fontSize - 4)),
      bodyLarge: GoogleFonts.poppins(
          textStyle: bodyLarge(color: Palette.blackColor, fontSize: fontSize)),
      bodyMedium: GoogleFonts.poppins(
          textStyle:
              bodyMedium(color: Palette.blackColor, fontSize: fontSize - 1)),
      bodySmall: GoogleFonts.poppins(
          textStyle:
              bodySmall(color: Palette.blackColor, fontSize: fontSize - 2)),
      labelLarge: GoogleFonts.poppins(
          textStyle:
              buttonTextStyle(color: Palette.blackColor, fontSize: fontSize)),
      labelMedium: GoogleFonts.poppins(
          textStyle:
              captionStyle(color: Palette.blackColor, fontSize: fontSize - 2)),
      labelSmall: GoogleFonts.poppins(
          textStyle:
              overlineStyle(color: Palette.blackColor, fontSize: fontSize - 4)),
    ),
    iconTheme: IconThemeData(color: Palette.themeColor, size: fontSize + 10),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      fillColor: Palette.lightGreyColor,
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      
        style: elevatedButtonStyle(

            fontSize: fontSize,
            foregroundColor: Palette.whiteColor,
            backgroundColor: Palette.themeColor)),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonStyle(
            fontSize: fontSize,
            foregroundColor: Palette.themeColor,
            borderColor: Palette.themeColor)),
    textButtonTheme: TextButtonThemeData(
        style: textButtonStyle(
            foregroundColor: Palette.themeColor, fontSize: fontSize)),
    extensions: <ThemeExtension<dynamic>>[
      BoxDecorationTheme(
        primaryDecoration: primaryBoxDecoration(color: Palette.whiteColor),
        secondaryDecoration: secondaryBoxDecoration(color: Palette.greyColor),
      ),
    ],
  );
}

ThemeData darkTheme(double fontSize) {
  return ThemeData(
    primaryColor: Palette.themeColor,
    colorScheme: const ColorScheme.dark(
      primary: Palette.themeColor,
      secondary: Palette.themeColor,
      surface: Palette.darkBackgroundColor,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 39, 39, 39),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.blackColor,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
          textStyle:
              headingLarge(color: Palette.whiteColor, fontSize: fontSize)),
      displayMedium: GoogleFonts.poppins(
          textStyle:
              headingMedium(color: Palette.whiteColor, fontSize: fontSize - 2)),
      displaySmall: GoogleFonts.poppins(
          textStyle:
              headingSmall(color: Palette.whiteColor, fontSize: fontSize - 4)),
      titleLarge: GoogleFonts.poppins(
          textStyle: titleLarge(color: Palette.whiteColor, fontSize: fontSize)),
      titleMedium: GoogleFonts.poppins(
          textStyle:
              titleMedium(color: Palette.whiteColor, fontSize: fontSize - 2)),
      titleSmall: GoogleFonts.poppins(
          textStyle:
              titleSmall(color: Palette.whiteColor, fontSize: fontSize - 4)),
      bodyLarge: GoogleFonts.poppins(
          textStyle: bodyLarge(color: Palette.whiteColor, fontSize: fontSize)),
      bodyMedium: GoogleFonts.poppins(
          textStyle:
              bodyMedium(color: Palette.whiteColor, fontSize: fontSize - 1)),
      bodySmall: GoogleFonts.poppins(
          textStyle:
              bodySmall(color: Palette.whiteColor, fontSize: fontSize - 2)),
      labelLarge: GoogleFonts.poppins(
          textStyle:
              buttonTextStyle(color: Palette.whiteColor, fontSize: fontSize)),
      labelMedium: GoogleFonts.poppins(
          textStyle:
              captionStyle(color: Palette.whiteColor, fontSize: fontSize - 2)),
      labelSmall: GoogleFonts.poppins(
          textStyle:
              overlineStyle(color: Palette.whiteColor, fontSize: fontSize - 4)),
    ),
    iconTheme: IconThemeData(
      color: Palette.lightGreyColor,
      size: fontSize + 10,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      fillColor: Palette.greyColor,
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle(
            fontSize: fontSize,
            foregroundColor: Palette.whiteColor,
            backgroundColor: Palette.themeColor)),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonStyle(
            fontSize: fontSize,
            foregroundColor: Palette.whiteColor,
            borderColor: Palette.themeColor)),
    textButtonTheme: TextButtonThemeData(
        style: textButtonStyle(
            foregroundColor: Palette.whiteColor, fontSize: fontSize)),
    extensions: <ThemeExtension<dynamic>>[
      BoxDecorationTheme(
        primaryDecoration:
            primaryBoxDecoration(color: Palette.darkBackgroundColor),
        secondaryDecoration: secondaryBoxDecoration(color: Palette.greyColor),
      ),
    ],
  );
}
