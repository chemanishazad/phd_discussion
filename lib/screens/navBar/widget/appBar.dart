import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Palette.themeColor,
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
