import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

final categoriesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return getCategories();
});

class Category {
  final String id;
  final String category;
  final List<Category>? children;

  Category({required this.id, required this.category, this.children});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => Category.fromJson(child))
              .toList()
          : null,
    );
  }
}

// Main Categories Screen
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Categories'),
      body: categoriesAsyncValue.when(
        data: (data) {
          // Parse the categories from the response
          List<Category> categories = (data['categories'] as List)
              .map((categoryJson) => Category.fromJson(categoryJson))
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: categories.map((category) {
                  return _buildExpansionTile(
                    context: context,
                    title: category.category,
                    children: category.children?.map((child) {
                          return _buildListTile(context, child);
                        }).toList() ??
                        [],
                  );
                }).toList(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // ExpansionTile for each category
  Widget _buildExpansionTile({
    required String title,
    required List<Widget> children,
    required BuildContext context,
  }) {
    return Container(
      decoration: cardDecoration(context: context),
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        children: children,
        iconColor: Palette.themeColor,
      ),
    );
  }

  // ListTile for each sub-category
  Widget _buildListTile(BuildContext context, Category category) {
    return ListTile(
      title: Text(category.category,
          style: Theme.of(context).textTheme.bodyMedium),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
      onTap: () {
        // Pass the selected category to the next screen
        Navigator.pushNamed(
          context,
          '/categoryQuestion',
          arguments: category.id,
        );
      },
    );
  }
}
