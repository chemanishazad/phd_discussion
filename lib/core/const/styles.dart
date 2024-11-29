import 'package:flutter/material.dart';
import 'palette.dart';

TextStyle headingLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle headingMedium(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle headingSmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.bold,
      color: color,
    );

// Title/Subtitle Styles
TextStyle titleLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle titleMedium(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle titleSmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle subtitle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w500,
      color: color,
    );

// Body Text Styles
TextStyle bodyLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle bodyMedium(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle bodySmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w400,
      color: color,
    );

// Button and Input Styles
TextStyle buttonTextStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle inputTextStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w500,
      color: color,
    );

// Caption/Label Styles
TextStyle captionStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle labelLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      color: color,
    );

TextStyle labelSmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      color: color,
    );

// Overline
TextStyle overlineStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize, // Use dynamic fontSize
      fontWeight: FontWeight.w300,
      color: color,
    );

// Box Decorations
BoxDecoration primaryBoxDecoration({required Color color}) => BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      boxShadow: const [
        BoxShadow(
          color: Palette.greyColor,
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: Offset(2.0, 2.0),
        ),
      ],
    );

BoxDecoration secondaryBoxDecoration({required Color color}) => BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    );

// Input Decorations
InputDecoration primaryInputDecoration({required Color fillColor}) =>
    InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );

InputDecoration searchInputDecoration({required Color fillColor}) =>
    InputDecoration(
      hintText: 'Search...',
      prefixIcon: const Icon(Icons.search, color: Palette.iconColor),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );

// Button Styles
ButtonStyle elevatedButtonStyle({
  required Color foregroundColor,
  required Color backgroundColor,
  required double? fontSize,
}) =>
    ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textStyle: buttonTextStyle(
        color: foregroundColor,
        fontSize: fontSize ?? 14,
      ),
    );

ButtonStyle outlinedButtonStyle({
  required Color foregroundColor,
  required Color borderColor,
  required double? fontSize,
}) =>
    OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: BorderSide(color: borderColor),
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textStyle: buttonTextStyle(
        color: foregroundColor,
        fontSize: fontSize ?? 14,
      ),
    );

ButtonStyle textButtonStyle(
        {required Color foregroundColor, required dynamic fontSize}) =>
    TextButton.styleFrom(
      foregroundColor: foregroundColor,
      textStyle:
          buttonTextStyle(color: foregroundColor, fontSize: fontSize ?? 14),
    );

// Icon Themes
IconThemeData iconTheme({required Color color, double size = 24.0}) =>
    IconThemeData(
      color: color,
      size: size,
    );

// Box Decoration Theme (Custom Theme Extension)
class BoxDecorationTheme extends ThemeExtension<BoxDecorationTheme> {
  final BoxDecoration primaryDecoration;
  final BoxDecoration secondaryDecoration;

  BoxDecorationTheme({
    required this.primaryDecoration,
    required this.secondaryDecoration,
  });

  @override
  BoxDecorationTheme copyWith({
    BoxDecoration? primaryDecoration,
    BoxDecoration? secondaryDecoration,
  }) {
    return BoxDecorationTheme(
      primaryDecoration: primaryDecoration ?? this.primaryDecoration,
      secondaryDecoration: secondaryDecoration ?? this.secondaryDecoration,
    );
  }

  @override
  BoxDecorationTheme lerp(ThemeExtension<BoxDecorationTheme>? other, double t) {
    if (other is! BoxDecorationTheme) return this;
    return BoxDecorationTheme(
      primaryDecoration:
          BoxDecoration.lerp(primaryDecoration, other.primaryDecoration, t)!,
      secondaryDecoration: BoxDecoration.lerp(
          secondaryDecoration, other.secondaryDecoration, t)!,
    );
  }
}
