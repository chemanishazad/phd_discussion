import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/skillSection.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategoryDetailsJob extends ConsumerStatefulWidget {
  const CategoryDetailsJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryDetailsJobState();
}

class _CategoryDetailsJobState extends ConsumerState<CategoryDetailsJob> {
  final ScrollController _scrollController = ScrollController();
  String categoryId = '';
  List<dynamic> jobs = [];
  bool isLoading = true;

  @override
  Future<void> didChangeDependencies() async {
    final arg = ModalRoute.of(context)!.settings.arguments as String;
    setState(() {
      categoryId = arg;
      isLoading = true;
    });
    if (categoryId.isNotEmpty) {
      final res =
          await ref.watch(jobCategoryListProvider({'id': categoryId}).future);
      if (res['status'] == true) {
        setState(() {
          jobs = res['jobs'];
          isLoading = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshJobs() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  final FormGroup form = FormGroup({
    'category': FormControl<String>(),
    'location': FormControl<String>(),
    'experience': FormControl<String>(),
    'salary': FormControl<String>(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : jobs.isEmpty
                ? const Center(child: Text('No Jobs Found'))
                : RefreshIndicator(
                    onRefresh: _refreshJobs,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 500,
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];

                        return Container(
                          decoration: cardDecoration(context: context),
                          margin: EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Job Title
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/jobDetailsScreen',
                                      arguments: job,
                                    );
                                  },
                                  child: Text(
                                    job['job_title'],
                                    style: theme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Company and Location
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        job['company'] ?? '',
                                        style: theme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        job['location_name'],
                                        style: theme.titleSmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Experience and Salary
                                Row(
                                  children: [
                                    const Icon(Icons.work_outline),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Experience: ${job['experience']} Years',
                                        style: theme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on_outlined),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Salary: ₹${job['salary']}',
                                        style: theme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Key Skills
                                Text(
                                  'Key Skills:',
                                  style: theme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SkillsWrap(skills: job['skills'].join(', ')),

                                // Apply Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/jobDetailsScreen',
                                            arguments: job);
                                      },
                                      child: const Text('View Details >'),
                                    ),
                                    if (job['is_applied'] != true)
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/jobApplyForm',
                                            arguments: job,
                                          ).then(
                                            (value) {
                                              _refreshJobs();
                                            },
                                          );
                                        },
                                        child: const Text(
                                          ' Apply Now > ',
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
