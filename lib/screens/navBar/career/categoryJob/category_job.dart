import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';

class CategoryJob extends ConsumerStatefulWidget {
  const CategoryJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryJobState();
}

class _CategoryJobState extends ConsumerState<CategoryJob> {
  final List<Map<String, String>> data = [
    {
      'id': '1',
      'title': 'Software Development',
      'icon_url': 'https://cdn-icons-png.flaticon.com/512/2721/2721275.png',
      'job_count': '150'
    },
    {
      'id': '2',
      'title': 'Data Science',
      'icon_url': 'https://cdn-icons-png.flaticon.com/512/4140/4140037.png',
      'job_count': '120'
    },
    {
      'id': '3',
      'title': 'Cyber Security',
      'icon_url': 'https://cdn-icons-png.flaticon.com/512/3197/3197561.png',
      'job_count': '90'
    },
    {
      'id': '4',
      'title': 'Marketing',
      'icon_url': 'https://cdn-icons-png.flaticon.com/512/1995/1995539.png',
      'job_count': '200'
    },
    {
      'id': '5',
      'title': 'Project Management',
      'icon_url': 'https://cdn-icons-png.flaticon.com/512/3272/3272390.png',
      'job_count': '75'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            var category = data[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CategoryCard(
                categoryName: category['title']!,
                categoryIconUrl: category['icon_url']!,
                jobCount: category['job_count']!,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/categoryJob',
                    arguments: {
                      'id': category['id'],
                      'name': category['title'],
                    },
                  );
                  print(category['id']);
                },
              ),
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
