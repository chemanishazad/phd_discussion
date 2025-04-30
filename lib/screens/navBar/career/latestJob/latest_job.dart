import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/filter_sheet.dart';
import 'package:phd_discussion/screens/navBar/career/latestJob/skillSection.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../merchandise/merchandiseHome/dummyData.dart';

class LatestJob extends ConsumerStatefulWidget {
  const LatestJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LatestJobState();
}

class _LatestJobState extends ConsumerState<LatestJob> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'Flutter Developer',
      'company': 'Tech Innovators',
      'location': 'Remote',
      'experience': '2+ years',
      'proposed_CTC': '6',
      'proposed_CTC_to': '10',
      'key_skills': ['Flutter', 'Dart', 'Firebase'],
    },
    {
      'title': 'Data Scientist',
      'company': 'AI Solutions Ltd.',
      'location': 'Bangalore',
      'experience': '3+ years',
      'proposed_CTC': '10',
      'proposed_CTC_to': '18',
      'key_skills': ['Python', 'Machine Learning', 'TensorFlow'],
    },
    {
      'title': 'Cyber Security Analyst',
      'company': 'SecureNet Inc.',
      'location': 'Delhi',
      'experience': '4+ years',
      'proposed_CTC': '8',
      'proposed_CTC_to': '14',
      'key_skills': ['Network Security', 'Ethical Hacking', 'Kali Linux'],
    },
    {
      'title': 'Digital Marketing Manager',
      'company': 'Growth Hackers',
      'location': 'Mumbai',
      'experience': '5+ years',
      'proposed_CTC': '7',
      'proposed_CTC_to': '12',
      'key_skills': ['SEO', 'Google Ads', 'Content Marketing'],
    },
  ];

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
          locationType: locationType,
          onApplyFilters: () {
            setState(() {});
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
              onPressed: () {
                openFilter(context);
              },
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
        child: RefreshIndicator(
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
                          job['title'],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              job['company'],
                              style: theme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              job['location'],
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
                              'Experience: ${job['experience']}',
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
                              'Salary: ₹${job['proposed_CTC']}L - ₹${job['proposed_CTC_to']}L',
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
                      SkillsWrap(skills: job['key_skills'].toString()),

                      // Apply Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/jobDetailsScreen');
                            },
                            child: const Text(
                              'View Details >',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, '/jobApplyForm');
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
