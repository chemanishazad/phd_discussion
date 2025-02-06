import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListWidget extends StatelessWidget {
  final AsyncValue<Map<String, dynamic>> categoriesAsyncValue;

  const CategoryListWidget({
    required this.categoriesAsyncValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: categoriesAsyncValue.when(
        data: (data) {
          final categoriesToShow = data['categories'].take(7).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categoriesToShow.map<Widget>((category) {
                int childrenCount = category['children']?.length ?? 0;

                return CategoryItem(
                  categoryIcon: Icon(
                    Icons.category,
                    color: Colors.black,
                  ),
                  categoryName: category['category'],
                  childrenCount: childrenCount,
                );
              }).toList(),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Oops! Something went wrong.\n$error')),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Icon categoryIcon;
  final String categoryName;
  final int childrenCount;

  final List<Color> colors = [
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
  ];
  final List<Color> cardColors = [
    Color.fromARGB(255, 255, 178, 178), // Soft Light Coral
    Color.fromARGB(255, 178, 255, 178), // Soft Light Mint Green
    Color.fromARGB(255, 178, 223, 255), // Soft Light Sky Blue
    Color.fromARGB(255, 255, 255, 153), // Soft Light Lemon Yellow
    Color.fromARGB(255, 255, 182, 255), // Soft Light Lavender
    Color.fromARGB(255, 178, 255, 255), // Soft Light Aqua
  ];

  CategoryItem({
    required this.categoryIcon,
    required this.categoryName,
    required this.childrenCount,
    Key? key,
  }) : super(key: key);

  Color getRandomColor() {
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final colorIndex = categoryName.hashCode % cardColors.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 0.1,
            color: Colors.transparent,
          ),
          gradient: LinearGradient(
            colors: [
              getRandomColor(),
              getRandomColor(),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    // Apply gradient here
                    colors: [
                      cardColors[colorIndex],
                      cardColors[(colorIndex + 1) % cardColors.length],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: categoryIcon,
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: Text(categoryName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black)),
                      ),
                      SizedBox(height: 6),
                      Text('$childrenCount items',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
