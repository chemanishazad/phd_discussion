import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

final updateProfileProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await updateAnswer(
    params['id']!,
    params['answer']!,
  );
});

class MyAnswerScreen extends ConsumerStatefulWidget {
  const MyAnswerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAnswerScreenState();
}

class _MyAnswerScreenState extends ConsumerState<MyAnswerScreen> {
  Future<void> _editAnswer(
      BuildContext context, String answerId, String currentAnswer) async {
    final QuillEditorController bodyController = QuillEditorController();

    // Set the current answer as the initial text in the editor
    bodyController.setText(currentAnswer);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                child: ToolBar(
                  controller: bodyController,
                ),
              ),
              QuillHtmlEditor(
                hintText: 'Type your answer here...',
                controller: bodyController,
                text: currentAnswer,
                isEnabled: true,
                minHeight: 300,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 5),
                hintTextPadding: EdgeInsets.zero,
                loadingBuilder: (context) {
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 0.4));
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                onTap: () async {
                  final updatedAnswer = await bodyController.getText();
                  print(updatedAnswer);
                  final response = await ref.read(updateProfileProvider(
                      {'id': answerId, 'answer': updatedAnswer}).future);
                  final Map<String, dynamic> jsonResponse =
                      jsonDecode(response.body);
                  print({'$jsonResponse.body'});
                  if (response.statusCode == 200) {
                    ref.refresh(profileProvider);
                    Navigator.pop(context);

                    Fluttertoast.showToast(msg: jsonResponse['message']);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Error voting: ${response.reasonPhrase}');
                  }
                },
                child: const Text(
                  'Update Answer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ref.refresh(profileProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Answers'),
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile['status'] == true) {
            final userData = profile['my_answers'];
            if (userData == null || userData.isEmpty) {
              // Show message when there's no data
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
                      'No Answers yet!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'When you add Answers, they will show up here.',
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
                final answer = userData[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  '${answer['added_by_user']['question']}',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                            answer['status'] == '0'
                                ? IconButton(
                                    onPressed: () => _editAnswer(context,
                                        answer['id'], answer['answer']),
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    tooltip: 'Edit Answer',
                                  )
                                : const SizedBox()
                          ],
                        ),
                        const SizedBox(height: 10),
                        HtmlWidget(
                          answer['answer'] ?? 'No answer provided',
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('By ${answer['added_by_user']['name']}',
                                style: Theme.of(context).textTheme.bodyMedium),
                            Container(
                              color: answer['status'] == '0'
                                  ? Colors.amber
                                  : Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  answer['status'] == '0'
                                      ? 'Pending'
                                      : 'Approved',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Added on',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Text(
                                  '${answer['added_by_user']['date']}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Answered on',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Text(
                                  '${answer['date']}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text('No answers found.',
                    style: Theme.of(context).textTheme.bodyMedium));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
