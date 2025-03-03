import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:intl/intl.dart';

class AppliedJob extends ConsumerStatefulWidget {
  const AppliedJob({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppliedJobState();
}

class _AppliedJobState extends ConsumerState<AppliedJob> {
  final dateFormat = DateFormat('dd-MM-yyyy');

  final List<Map<String, dynamic>> jobs = [
    {
      "jobTitle": "Flutter Developer",
      "company": "Tech Solutions Ltd",
      "location": "Bangalore",
      "dateApplied": "2024-02-10",
      "fld_proposed_ctc": "8",
      "fld_proposed_ctc_to": "12",
      "fld_experience": "5 years",
      "status": "Shortlist",
    },
    {
      "jobTitle": "Senior Software Engineer",
      "company": "Innovatech Pvt Ltd",
      "location": "Chennai",
      "dateApplied": "2024-01-25",
      "fld_proposed_ctc": "12",
      "fld_proposed_ctc_to": "18",
      "fld_experience": "7 years",
      "status": "Pending",
    },
    {
      "jobTitle": "Mobile App Developer",
      "company": "NextGen Apps",
      "location": "Mumbai",
      "dateApplied": "2024-02-15",
      "fld_proposed_ctc": "6",
      "fld_proposed_ctc_to": "10",
      "fld_experience": "4 years",
      "status": "Rejected",
    },
    {
      "jobTitle": "Lead Flutter Engineer",
      "company": "SmartTech",
      "location": "Pune",
      "dateApplied": "2024-02-05",
      "fld_proposed_ctc": "15",
      "fld_proposed_ctc_to": "20",
      "fld_experience": "8 years",
      "status": "Shortlist",
    },
    {
      "jobTitle": "UI/UX Designer",
      "company": "Creative Minds",
      "location": "Delhi",
      "dateApplied": "2024-01-20",
      "fld_proposed_ctc": "5",
      "fld_proposed_ctc_to": "8",
      "fld_experience": "3 years",
      "status": "Pending",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index];

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
                            job['jobTitle'] ?? 'Job Title',
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
                                  job['location'] ?? 'Location',
                                  style: theme.bodyLarge,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                job['dateApplied'] != null
                                    ? dateFormat.format(
                                        DateTime.parse(job['dateApplied']))
                                    : 'Date Applied',
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
                                'Salary: ${job['fld_proposed_ctc']}lakhs to ${(job['fld_proposed_ctc_to']) ?? ''}lakhs',
                                style: theme.bodyMedium,
                              ),
                              const Spacer(),
                              const Icon(Icons.work_outline,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Experience: ${job['fld_experience']}',
                                style: theme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: job['status'] == 'Shortlist'
                                      ? Colors.green.withOpacity(0.1)
                                      : job['status'] == 'Pending'
                                          ? Colors.orange.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: job['status'] == 'Shortlist'
                                        ? Colors.green
                                        : job['status'] == 'Pending'
                                            ? Colors.orange
                                            : Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      job['status'] == 'Shortlist'
                                          ? Icons.check_circle
                                          : job['status'] == 'Pending'
                                              ? Icons.access_time
                                              : Icons.cancel,
                                      color: job['status'] == 'Shortlist'
                                          ? Colors.green
                                          : job['status'] == 'Pending'
                                              ? Colors.orange
                                              : Colors.red,
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      job['status'] ?? 'Status',
                                      style: theme.bodyMedium?.copyWith(
                                        color: job['status'] == 'Shortlist'
                                            ? Colors.green
                                            : job['status'] == 'Pending'
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
          )
        ],
      ),
    );
  }
}
