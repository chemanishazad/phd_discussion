import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

// Future provider to get categories
final categoriesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getCategories(); // Assuming getCategories is an async function that fetches the data
});

// StateNotifierProvider to manage the expanded index state
final expandedIndexProvider =
    StateNotifierProvider<ExpandedIndexNotifier, int?>((ref) {
  return ExpandedIndexNotifier();
});

// StateNotifier to manage the expanded index
class ExpandedIndexNotifier extends StateNotifier<int?> {
  ExpandedIndexNotifier() : super(null);

  void setExpandedIndex(int? index) {
    if (state == index) {
      state = null; // Collapse the tile if it's already expanded
    } else {
      state = index; // Expand the clicked tile
    }
  }
}

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

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final expandedIndex = ref.watch(expandedIndexProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Categories'),
      body: categoriesAsyncValue.when(
        data: (data) {
          List<Category> categories = (data['categories'] as List)
              .map((categoryJson) => Category.fromJson(categoryJson))
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  Category category = entry.value;

                  return _buildCustomExpansionTile(
                    context: context,
                    title: category.category,
                    index: index,
                    isOpen:
                        expandedIndex == index, // Check if the tile is expanded
                    children: category.children?.map((child) {
                          return _buildListTile(context, child);
                        }).toList() ??
                        [],
                    onExpansionChanged: () {
                      ref
                          .read(expandedIndexProvider.notifier)
                          .setExpandedIndex(index);
                    },
                    showNoData: category.children == null ||
                        category
                            .children!.isEmpty, // Show No Data if no children
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

  Widget _buildCustomExpansionTile({
    required String title,
    required List<Widget> children,
    required BuildContext context,
    required int index,
    required bool isOpen,
    required Function onExpansionChanged,
    required bool showNoData,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        decoration: cardDecoration(context: context),
        child: Column(
          children: [
            ListTile(
              title: Text(title, style: Theme.of(context).textTheme.titleLarge),
              trailing: Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Palette.themeColor),
              onTap: () => onExpansionChanged(), // Trigger expansion toggle
            ),
            if (isOpen) ...children, // Show children if expanded
            if (isOpen &&
                showNoData) // Display No Data message if there are no children
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No data available',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Category category) {
    return ListTile(
      title: Text(category.category,
          style: Theme.of(context).textTheme.bodyMedium),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/categoryQuestion',
          arguments: category.id,
        );
      },
    );
  }
}
