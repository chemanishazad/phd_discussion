import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';

class MerchandiseCategory extends ConsumerStatefulWidget {
  const MerchandiseCategory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MerchandiseCategoryState();
}

class _MerchandiseCategoryState extends ConsumerState<MerchandiseCategory> {
  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.book, "label": "Books"},
    {"icon": Icons.local_cafe, "label": "Mugs"},
    {"icon": Icons.shopping_bag, "label": "T-Shirts"},
    {"icon": Icons.checkroom, "label": "Hoodies"},
    {"icon": Icons.backpack, "label": "Backpacks"},
    {"icon": Icons.local_drink, "label": "Water Bottles"},
    {"icon": Icons.phone_iphone, "label": "Phone Cases"},
    {"icon": Icons.watch, "label": "Accessories"},
    {"icon": Icons.laptop_mac, "label": "Laptop Skins"},
    {"icon": Icons.music_note, "label": "Vinyl & CDs"},
    {"icon": Icons.palette, "label": "Art Prints"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.separated(
          itemCount: categories.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: Icon(category["icon"]),
              title: Text(
                category["label"],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                // TODO: Implement category navigation
              },
            );
          },
        ),
      ),
    );
  }
}
