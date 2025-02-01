import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:intl/intl.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

final deleteQuestionProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await deleteQuestion(params['id']!);
});

class MyQuestionScreen extends ConsumerStatefulWidget {
  const MyQuestionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyQuestionScreenState();
}

class _MyQuestionScreenState extends ConsumerState<MyQuestionScreen> {
  @override
  void initState() {
    super.initState();
    ref.refresh(profileProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Questions'),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(profileProvider);
        },
        child: profileAsyncValue.when(
          data: (profile) {
            if (profile['status'] == true) {
              final userData = profile['my_questions'];
              if (userData == null || userData.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No questions yet!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'When you add questions, they will show up here.',
                        style: TextStyle(fontSize: 14, color: Colors.black38),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  final question = userData[index];

                  List<String> tags = [];
                  if (question['tags'] is String) {
                    tags = List<String>.from(jsonDecode(question['tags'])
                        .map((tag) => tag['name'] as String));
                  } else if (question['tags'] is List) {
                    tags = question['tags']
                        .map<String>((tag) => tag['name'] as String)
                        .toList();
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Container(
                      decoration: cardDecoration(context: context),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question['title'] ?? 'No title',
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(height: 4),
                            Text(question['sub_title'] ?? '',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 10),
                            HtmlWidget(
                                question['body'] ?? 'No content provided',
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 4.0,
                              children: tags.map<Widget>((tag) {
                                return Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(tag),
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoColumn(Icons.calendar_today,
                                    _formatDate(question['date'])),
                                _buildInfoColumn(
                                    Icons.thumb_up, question['votes']),
                                _buildInfoColumn(
                                    Icons.comment, question['comments']),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.edit,
                                            color: Colors.blue),
                                        Text('Edit')
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                              context, '/editQuestionScreen',
                                              arguments: question)
                                          .then(
                                        (value) {
                                          ref.refresh(profileProvider);
                                        },
                                      );
                                    }),
                                SizedBox(width: 16),
                                InkWell(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete,
                                          color: Colors.red),
                                      Text('Delete')
                                    ],
                                  ),
                                  onTap: () async {
                                    // Show confirmation dialog
                                    bool? confirmDelete =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this question?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: Text('No',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text('Yes',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // If user confirmed, proceed with the API call
                                    if (confirmDelete == true) {
                                      try {
                                        final response = await ref.read(
                                            deleteQuestionProvider(
                                                {'id': question['id']}).future);
                                        final Map<String, dynamic>
                                            jsonResponse =
                                            jsonDecode(response.body);
                                        print(jsonResponse);

                                        if (response.statusCode == 200) {
                                          ref.refresh(profileProvider);
                                          Fluttertoast.showToast(
                                              msg: jsonResponse['message']);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Error deleting: ${response.reasonPhrase}');
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: 'Error: $e');
                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text('No questions found.',
                      style: TextStyle(fontSize: 18)));
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd MM yyyy').format(dateTime);
  }

  Widget _buildInfoColumn(IconData icon, String? value) {
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 4),
        Text(value ?? '0', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
