import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

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

              return ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  final question = userData[index];

                  List<dynamic> tags = [];
                  if (question['tags'] is String) {
                    tags = jsonDecode(question['tags']);
                  } else if (question['tags'] is List) {
                    tags = question['tags'];
                  }

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['title'] ?? 'No title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question['sub_title'] ?? '',
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          HtmlWidget(
                            question['body'] ?? 'No content provided',
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8.0,
                            children: tags.map<Widget>((tag) {
                              return Chip(
                                label: Text(tag),
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.2),
                              );
                            }).toList(),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn('Added on', question['date']),
                              _buildInfoColumn('Votes', question['votes']),
                              _buildInfoColumn(
                                  'Comments', question['comments']),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  print(question);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final response = await ref.read(
                                      deleteQuestionProvider(
                                          {'id': question['id']}).future);
                                  final Map<String, dynamic> jsonResponse =
                                      jsonDecode(response.body);
                                  print({'$jsonResponse.body'});
                                  if (response.statusCode == 200) {
                                    ref.refresh(profileProvider);
                                    // Navigator.pop(context);

                                    Fluttertoast.showToast(
                                        msg: jsonResponse['message']);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Error voting: ${response.reasonPhrase}');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildInfoColumn(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value ?? '0',
            style: const TextStyle(color: Colors.black54, fontSize: 14)),
      ],
    );
  }
}
