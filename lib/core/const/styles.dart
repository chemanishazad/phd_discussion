import 'package:flutter/material.dart';
import 'palette.dart';

// Heading Styles
TextStyle displayLarge({required Color color}) => TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle displayMedium({required Color color}) => TextStyle(
      fontSize: 23.0,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle displaySmall({required Color color}) => TextStyle(
      fontSize: 21.0,
      fontWeight: FontWeight.bold,
      color: color,
    );

// Title/Subtitle Styles
TextStyle headlineLarge({required Color color}) => TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle headlineMedium({required Color color}) => TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle headlineSmall({required Color color}) => TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle subtitle2({required Color color}) => TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: color,
    );

// Body Text Styles
TextStyle titleLarge({required Color color}) => TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle titleMedium({required Color color}) => TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle titleSmall({required Color color}) => TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
      color: color,
    );

// Button and Input Styles
TextStyle buttonText({required Color color}) => TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle primaryButton({required Color color}) => TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: color,
    );

// Caption/Label Styles
TextStyle caption({required Color color}) => TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle labelLarge({required Color color}) => TextStyle(
      fontSize: 11.0,
      color: color,
    );

TextStyle labelSmall({required Color color}) => TextStyle(
      fontSize: 10.0,
      color: color,
    );

// Overline
TextStyle overline({required Color color}) => TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w300,
      color: color,
    );
// Box Decorations
BoxDecoration primaryBoxDecoration(Color color) => BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      boxShadow: const [
        BoxShadow(
          color: Palette.greyColor,
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: Offset(2.0, 2.0),
        ),
      ],
    );

BoxDecoration secondaryBoxDecoration(Color color) => BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      boxShadow: const [
        BoxShadow(
          color: Palette.greyColor,
          blurRadius: 3.0,
          spreadRadius: 1.0,
          offset: Offset(1.0, 1.0),
        ),
      ],
    );

// Input Decorations
InputDecoration primaryInputDecoration(Color color) => InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      filled: true,
      fillColor: color,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );

InputDecoration searchInputDecoration(Color color) => InputDecoration(
      hintText: 'Search...',
      prefixIcon: const Icon(Icons.search, color: Palette.iconColor),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      filled: true,
      fillColor: color,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );

// Button Styles
ButtonStyle primaryElevatedButtonStyle(
        Color foregroundColor, Color backgroundColor) =>
    ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textStyle: primaryButton(color: foregroundColor),
    );

ButtonStyle primaryOutlinedButtonStyle(
        Color foregroundColor, Color sideColor) =>
    OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: BorderSide(color: sideColor),
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textStyle: primaryButton(color: foregroundColor),
    );

ButtonStyle primaryTextButtonStyle(Color foregroundColor) =>
    TextButton.styleFrom(
      foregroundColor: foregroundColor,
      textStyle: primaryButton(color: foregroundColor),
    );

// Icon Themes
IconThemeData primaryIconThemeData(Color color) => IconThemeData(
      color: color,
      size: 24.0,
    );

class BoxDecorationTheme extends ThemeExtension<BoxDecorationTheme> {
  final BoxDecoration primaryBoxDecoration;
  final BoxDecoration secondaryBoxDecoration;

  BoxDecorationTheme({
    required this.primaryBoxDecoration,
    required this.secondaryBoxDecoration,
  });

  @override
  BoxDecorationTheme copyWith({
    BoxDecoration? primaryBoxDecoration,
    BoxDecoration? secondaryBoxDecoration,
  }) {
    return BoxDecorationTheme(
      primaryBoxDecoration: primaryBoxDecoration ?? this.primaryBoxDecoration,
      secondaryBoxDecoration:
          secondaryBoxDecoration ?? this.secondaryBoxDecoration,
    );
  }

  @override
  BoxDecorationTheme lerp(ThemeExtension<BoxDecorationTheme>? other, double t) {
    if (other is! BoxDecorationTheme) return this;
    return BoxDecorationTheme(
      primaryBoxDecoration: BoxDecoration.lerp(
          primaryBoxDecoration, other.primaryBoxDecoration, t)!,
      secondaryBoxDecoration: BoxDecoration.lerp(
          secondaryBoxDecoration, other.secondaryBoxDecoration, t)!,
    );
  }
}
