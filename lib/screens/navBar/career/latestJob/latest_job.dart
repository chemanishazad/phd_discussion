import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/filter_sheet.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/skillSection.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LatestJob extends ConsumerStatefulWidget {
  const LatestJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LatestJobState();
}

class _LatestJobState extends ConsumerState<LatestJob> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> jobs = [];
  List<dynamic> location = [];
  List<dynamic> categories = [];
  bool isLoading = false;
  final FormGroup form = FormGroup({
    'category': FormControl<String>(),
    'location': FormControl<String>(),
    'experience': FormControl<String>(),
    'salary': FormControl<String>(),
    'min_salary': FormControl<String>(),
    'max_salary': FormControl<String>(),
  });

  @override
  void didChangeDependencies() {
    _initialFetch();
    super.didChangeDependencies();
  }

  Future<void> _initialFetch() async {
    setState(() {
      isLoading = true;
    });
    final loc = await ref.read(locationProvider.future);
    final cat = await ref.read(categoriesProvider.future);
    final res = await ref.read(latestJobListProvider({
      'category': '',
      'location': '',
      'experience': '',
      'fromSalary': '',
      'toSalary': '',
    }).future);
    setState(() {
      jobs = res['jobs'];
      isLoading = false;
      location = loc['categories'];
      categories = cat['categories'];
    });
  }

  Future<void> _refreshJobs() async {
    await _initialFetch();
  }

  void openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return FilterBottomSheet(
          form: form,
          locationType: location,
          categoryType: categories,
          onApplyFilters: () async {
            setState(() {
              isLoading = true;
            });
            final formValue = form.value;

            final filters = {
              'category': formValue['category'] ?? '',
              'location': formValue['location'] ?? '',
              'experience': formValue['experience'] ?? '',
              'fromSalary': formValue['min_salary']?.toString() ?? '',
              'toSalary': formValue['max_salary']?.toString() ?? '',
            };

            print(filters);

            final res = await ref.read(latestJobListProvider(filters).future);
            setState(() {
              jobs = res['jobs'];
              isLoading = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
        actions: [
          IconButton(
            onPressed: () => openFilter(context),
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _refreshJobs();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(child: Text('No Jobs Found'))
              : RefreshIndicator(
                  onRefresh: _refreshJobs,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 500,
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];

                        return Container(
                          decoration: cardDecoration(context: context),
                          margin: const EdgeInsets.only(bottom: 8),
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
                                    job['job_title'] ?? '',
                                    style: theme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Company (Optional if available) and Location
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        job['category_name'] ?? '',
                                        style: theme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        job['location_name'] ?? '',
                                        style: theme.titleSmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Experience
                                Row(
                                  children: [
                                    const Icon(Icons.work_outline),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Experience: ${job['experience'] ?? '-'} years',
                                        style: theme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Salary
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on_outlined),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Salary: ₹${job['from_salary']}L - ₹${job['to_salary']}L',
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
                                SkillsWrap(
                                  skills: (job['skills'] as List<dynamic>)
                                      .join(', '),
                                ),

                                // Action Buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/jobDetailsScreen',
                                          arguments: job,
                                        );
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
                                        child: const Text(' Apply Now > '),
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
