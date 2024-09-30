// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color color;
  final double borderRadius;
  final double elevation;
  final double padding;
  final double? height;
  final double? width;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color = Palette.themeColor,
    this.borderRadius = 8.0,
    this.elevation = 4.0,
    this.padding = 6.0,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Material(
        elevation: elevation,
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            child: child,
          ),
        ),
      ),
    );
  }
}
