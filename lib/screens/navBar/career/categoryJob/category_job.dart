import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';

class CategoryJob extends ConsumerStatefulWidget {
  const CategoryJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryJobState();
}

class _CategoryJobState extends ConsumerState<CategoryJob> {
  @override
  Widget build(BuildContext context) {
    final res = ref.watch(jobCategoriesProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: res.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (data) {
            return ListView.builder(
              itemCount: data['data']['categories'].length,
              itemBuilder: (context, index) {
                final category = data['data']['categories'][index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CategoryCard(
                    categoryName: category['category_name'] ?? '',
                    categoryIconUrl: category['category_image'] ?? '',
                    jobCount: category['job_count'] ?? '',
                    onTap: () {
                      Navigator.pushNamed(context, '/categoryDetailsJob',
                          arguments: category['category_id']);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String categoryIconUrl;
  final String jobCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.categoryIconUrl,
    required this.jobCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: cardDecoration(context: context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Circular image with placeholder
              ClipOval(
                child: Image.network(
                  categoryIconUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 50),
                ),
              ),
              const SizedBox(width: 16),
              // Category name and job count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: theme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('$jobCount jobs', style: theme.bodySmall),
                  ],
                ),
              ),
              // Forward arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
