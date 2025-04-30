import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:phd_discussion/core/const/palette.dart';

import 'skillSection.dart';

final List<Map<String, dynamic>> job = [
  {
    'fld_title': 'Software Engineer',
    'fld_company_name': 'Tech Corp Inc.',
    'fld_job_description':
        '<p>We are looking for a skilled Software Engineer to join our team...</p>',
    'fld_location': 'San Francisco, CA',
    'fld_proposed_CTC': '15',
    'fld_proposed_CTC_to': '20',
    'fld_experience': '3-5 years',
    'fld_industry': 'Information Technology',
    'fld_category': 'Software Development',
    'fld_other_benefits':
        'Health insurance, Paid time off, Remote work options',
    'fld_no_of_position': '2',
    'graduation_qualifications': [
      {
        'fld_course_name': 'Bachelor of Science',
        'fld_course_specialization': 'Computer Science',
      }
    ],
    'post_graduation_qualifications': [
      {
        'fld_course_name': 'Master of Science',
        'fld_course_specialization': 'Software Engineering',
      }
    ],
    'fld_key_skills': 'Java, Python, SQL, React, Node.js',
  }
];

class JobDetailsScreen extends ConsumerWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.themeColor,
          title: const Text(
            "Job Details",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job[0]['fld_title'],
                  style: theme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  job[0]['fld_company_name'],
                  style: theme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  "Job Description",
                  style: theme.headlineMedium,
                ),
                const SizedBox(height: 8),
                HtmlWidget(job[0]['fld_job_description']),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Perks & Benefits", style: theme.titleLarge),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.location_pin,
                      iconColor: Colors.blue,
                      title: "Location",
                      label: job[0]['fld_location'] ?? 'Not specified',
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.currency_rupee_outlined,
                      iconColor: Colors.green,
                      title: "Salary",
                      label:
                          "₹ ${job[0]['fld_proposed_CTC']} lakhs - ₹ ${job[0]['fld_proposed_CTC_to']} lakhs",
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.work_history,
                      iconColor: Colors.orange,
                      title: "Experience",
                      label: "${job[0]['fld_experience']}",
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.business,
                      iconColor: Colors.purple,
                      title: "Industry",
                      label: job[0]['fld_industry'] ?? 'Not specified',
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.category,
                      iconColor: Colors.amber,
                      title: "Category",
                      label: job[0]['fld_category'] ?? 'Not specified',
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.card_giftcard,
                      iconColor: Colors.red,
                      title: "Benefits",
                      label: job[0]['fld_other_benefits'] ??
                          'No additional benefits specified',
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.people,
                      iconColor: Colors.teal,
                      title: "Positions",
                      label:
                          "${job[0]['fld_no_of_position'] ?? 'Not specified'}",
                      theme: theme,
                    ),
                  ],
                ),
                if (job[0]['graduation_qualifications'] != null &&
                    job[0]['graduation_qualifications'].isNotEmpty)
                  const Divider(),
                if (job[0]['graduation_qualifications'] != null &&
                    job[0]['graduation_qualifications'].isNotEmpty)
                  Text("Qualifications", style: theme.titleLarge),
                // Qualification Row
                Column(
                  children: [
                    // Graduation Qualification Row
                    if (job[0]['graduation_qualifications'] != null &&
                        job[0]['graduation_qualifications'].isNotEmpty)
                      _buildInfoRow(
                        icon: Icons.school,
                        iconColor: Colors.blue,
                        title: "Graduation",
                        label: (job[0]['graduation_qualifications'][0]
                                    ['fld_course_name'] ??
                                '') +
                            (job[0]['graduation_qualifications'][0]
                                            ['fld_course_specialization'] !=
                                        null &&
                                    job[0]['graduation_qualifications'][0]
                                            ['fld_course_specialization']
                                        .isNotEmpty
                                ? ' (${job[0]['graduation_qualifications'][0]['fld_course_specialization']})'
                                : ''),
                        theme: theme,
                      ),

                    // Post Graduation Qualification Row
                    if (job[0]['post_graduation_qualifications'] != null &&
                        job[0]['post_graduation_qualifications'].isNotEmpty)
                      _buildInfoRow(
                        icon: Icons.school,
                        iconColor: Colors.blue,
                        title: "Post Graduation",
                        label: (job[0]['post_graduation_qualifications'][0]
                                    ['fld_course_name'] ??
                                '') +
                            (job[0]['post_graduation_qualifications'][0]
                                            ['fld_course_specialization'] !=
                                        null &&
                                    job[0]['post_graduation_qualifications'][0]
                                            ['fld_course_specialization']
                                        .isNotEmpty
                                ? ' (${job[0]['post_graduation_qualifications'][0]['fld_course_specialization']})'
                                : ''),
                        theme: theme,
                      ),
                  ],
                ),
                const Divider(),
                Text("Key Skills", style: theme.headlineMedium),
                SkillsWrap(skills: job[0]['fld_key_skills'] ?? ''),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {},
                    child: const Text(' Apply Now > '),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String label,
    required TextTheme theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.bodyMedium,
                children: [
                  TextSpan(
                    text: "$title: ", // Title before the label
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: label, // The actual data
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
