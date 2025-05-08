import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:intl/intl.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';

class AppliedJob extends ConsumerStatefulWidget {
  const AppliedJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppliedJobState();
}

class _AppliedJobState extends ConsumerState<AppliedJob> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final async = ref.watch(appliedJobProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: Column(
        children: [
          async.when(
            data: (jobs) {
              return Expanded(
                child: ListView.builder(
                  itemCount: jobs['jobs'].length,
                  itemBuilder: (context, index) {
                    var job = jobs['jobs'][index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
                      child: Container(
                        decoration: cardDecoration(context: context),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job Title and Company
                              Text(
                                job['job_title'] ?? 'Job Title',
                                style: theme.headlineLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                job['company'] ?? 'Company Name',
                                style: theme.bodyLarge,
                              ),
                              const SizedBox(height: 12),

                              // Location and Date Applied
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 18, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      job['location_name'] ?? 'Location',
                                      style: theme.bodyLarge,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.calendar_today,
                                      size: 18, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    job['applied_on'],
                                    style: theme.bodyLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Salary and Experience
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on_outlined,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Salary: ${job['salary']}',
                                    style: theme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.work_outline,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Experience: ${job['experience']} Years',
                                    style: theme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: job['apply_status_name'] ==
                                              'Recruited'
                                          ? Colors.green.withOpacity(0.1)
                                          : job['apply_status_name'] ==
                                                  'Pending'
                                              ? Colors.orange.withOpacity(0.1)
                                              : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: job['apply_status_name'] ==
                                                'Recruited'
                                            ? Colors.green
                                            : job['apply_status_name'] ==
                                                    'Pending'
                                                ? Colors.orange
                                                : Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          job['apply_status_name'] ==
                                                  'Recruited'
                                              ? Icons.check_circle
                                              : job['apply_status_name'] ==
                                                      'Pending'
                                                  ? Icons.access_time
                                                  : Icons.cancel,
                                          color: job['apply_status_name'] ==
                                                  'Recruited'
                                              ? Colors.green
                                              : job['apply_status_name'] ==
                                                      'Pending'
                                                  ? Colors.orange
                                                  : Colors.red,
                                          size: 14.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          job['apply_status_name'] ?? 'Status',
                                          style: theme.bodyMedium?.copyWith(
                                            color: job['apply_status_name'] ==
                                                    'Recruited'
                                                ? Colors.green
                                                : job['apply_status_name'] ==
                                                        'Pending'
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
          )
        ],
      ),
    );
  }
}
