import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';
import 'skillSection.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  List<dynamic> jobs = [];
  bool isLoading = true;

  @override
  Future<void> didChangeDependencies() async {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      isLoading = true;
    });

    if (arg.isNotEmpty) {
      final res = await ref.watch(jobCategoryListProvider({
        'id': arg['category_id'],
        'jobId': arg['id'],
      }).future);
      if (res['status'] == true) {
        setState(() {
          jobs = res['jobs'];
          isLoading = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(child: Text('No Jobs Found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(builder: (context) {
                    final job = jobs[0];
                    final qualifications =
                        job['qualifications'] as Map<String, dynamic>? ?? {};
                    final graduationList = qualifications['Graduation'] ?? [];
                    final postGraduationList =
                        qualifications['Post Graduation'] ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['job_title'] ?? 'Untitled Job',
                          style: theme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          job['company_name']?.toString().trim().isNotEmpty ==
                                  true
                              ? job['company_name']
                              : 'Company Name Not Provided',
                          style: theme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text("Job Description", style: theme.headlineMedium),
                        const SizedBox(height: 8),
                        HtmlWidget(job['job_description'] ?? 'No description'),
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
                              label: job['location_name'] ?? 'Not specified',
                              theme: theme,
                            ),
                            _buildInfoRow(
                              icon: Icons.currency_rupee_outlined,
                              iconColor: Colors.green,
                              title: "Salary",
                              label:
                                  "₹ ${job['from_salary']} Lacs - ₹ ${job['to_salary']} Lacs",
                              theme: theme,
                            ),
                            _buildInfoRow(
                              icon: Icons.work_history,
                              iconColor: Colors.orange,
                              title: "Experience",
                              label: job['experience'] ?? 'Not specified',
                              theme: theme,
                            ),
                            _buildInfoRow(
                              icon: Icons.business,
                              iconColor: Colors.purple,
                              title: "Industry",
                              label: job['industry_name'] ?? 'Not specified',
                              theme: theme,
                            ),
                            _buildInfoRow(
                              icon: Icons.category,
                              iconColor: Colors.amber,
                              title: "Category",
                              label: job['category_name'] ?? 'Not specified',
                              theme: theme,
                            ),
                            _buildInfoRow(
                              icon: Icons.card_giftcard,
                              iconColor: Colors.red,
                              title: "Benefits",
                              label: job['other_benefits'] ??
                                  'No additional benefits specified',
                              theme: theme,
                            ),
                            _buildInfoRow(
                              icon: Icons.people,
                              iconColor: Colors.teal,
                              title: "Positions",
                              label: job['no_of_positions'] ?? 'Not specified',
                              theme: theme,
                            ),
                          ],
                        ),
                        if (graduationList.isNotEmpty ||
                            postGraduationList.isNotEmpty)
                          const Divider(),
                        if (graduationList.isNotEmpty ||
                            postGraduationList.isNotEmpty)
                          Text("Qualifications", style: theme.titleLarge),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (graduationList.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text("Graduation", style: theme.titleMedium),
                              ...graduationList.map<Widget>((item) {
                                return _buildInfoRow(
                                  icon: Icons.school,
                                  iconColor: Colors.blue,
                                  title: item['course_name'] ?? '',
                                  label: item['specialization'] ?? '',
                                  theme: theme,
                                );
                              }).toList(),
                            ],
                            if (postGraduationList.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text("Post Graduation", style: theme.titleMedium),
                              ...postGraduationList.map<Widget>((item) {
                                return _buildInfoRow(
                                  icon: Icons.school,
                                  iconColor: Colors.green,
                                  title: item['course_name'] ?? '',
                                  label: item['specialization'] ?? '',
                                  theme: theme,
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                        const Divider(),
                        Text("Key Skills", style: theme.headlineMedium),
                        SkillsWrap(
                            skills:
                                (job['skills'] as List<dynamic>).join(', ')),
                        const SizedBox(height: 8),
                        if (job['is_applied'] != false)
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/jobApplyForm',
                                  arguments: job,
                                ).then(
                                  (value) {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: const Text(' Apply Now > '),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
    );
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
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: label),
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
