import 'package:flutter/material.dart';
import 'palette.dart';

TextStyle headingLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle headingMedium(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle headingSmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle titleLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );

TextStyle titleMedium(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );

TextStyle titleSmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );

// Body Text Styles
TextStyle bodyLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle bodyMedium(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle bodySmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );

// Button and Input Styles
TextStyle buttonTextStyle({
  required Color color,
  required double fontSize,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );
}

TextStyle inputTextStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );

// Caption/Label Styles
TextStyle captionStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle labelLarge(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      color: color,
    );

TextStyle labelSmall(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
      color: color,
    );

// Overline
TextStyle overlineStyle(
        {Color color = Palette.blackColor, required double fontSize}) =>
    TextStyle(
      fontSize: fontSize,
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
InputDecoration primaryInputDecoration(
        {required Color fillColor, String? hintText}) =>
    InputDecoration(
      hintText: hintText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );

InputDecoration searchInputDecoration({required Color fillColor}) =>
    primaryInputDecoration(fillColor: fillColor, hintText: 'Search...')
        .copyWith(
      prefixIcon: const Icon(Icons.search, color: Palette.iconColor),
    );

// Button Styles
ButtonStyle elevatedButtonStyle({
  required Color foregroundColor,
  required Color backgroundColor,
  required double fontSize,
}) =>
    ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.3,
        vertical: fontSize * 0.3,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      textStyle: bodyMedium(color: foregroundColor, fontSize: fontSize),
      minimumSize: Size(fontSize * 5, fontSize * 2),
    );

ButtonStyle outlinedButtonStyle({
  required Color foregroundColor,
  required Color borderColor,
  required double fontSize,
}) =>
    OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: BorderSide(color: borderColor),
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.3,
        vertical: fontSize * 0.3,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      textStyle: bodyMedium(color: foregroundColor, fontSize: fontSize),
      minimumSize: Size(fontSize * 5, fontSize * 2),
    );

ButtonStyle textButtonStyle({
  required Color foregroundColor,
  required double fontSize,
}) =>
    TextButton.styleFrom(
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.3,
        vertical: fontSize * 0.3,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      textStyle: bodyMedium(color: foregroundColor, fontSize: fontSize),
      minimumSize: Size(fontSize * 5, fontSize * 2),
    );

// Icon Themes
IconThemeData iconTheme({required Color color, double size = 24.0}) =>
    IconThemeData(color: color, size: size);

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

BoxDecoration cardDecoration({
  required BuildContext context,
  double borderRadius = 8.0,
  double elevation = 8.0,
  bool isHovering = false,
}) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return BoxDecoration(
    color: isDarkMode ? Palette.darkGreyColor : Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    border: Border.all(
      color:
          isDarkMode ? Palette.themeColor : Palette.blackColor.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.15),
        blurRadius: elevation,
        offset: Offset(0, elevation),
        spreadRadius: 1.5,
      ),
    ],
  );
}

BoxDecoration boxDecoration({
  required BuildContext context,
  double borderRadius = 2.0,
  double elevation = 8.0,
  bool isHovering = false,
}) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return BoxDecoration(
    color: isDarkMode ? Palette.darkGreyColor : Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    border: Border.all(
      color:
          isDarkMode ? Palette.themeColor : Palette.blackColor.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.15),
        blurRadius: elevation,
        offset: Offset(0, elevation),
        spreadRadius: 1.5,
      ),
    ],
  );
}
