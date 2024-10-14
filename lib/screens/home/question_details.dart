import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import 'widgets/comment_section.dart';
import 'widgets/related_question.dart';

class QuestionDetails extends ConsumerStatefulWidget {
  const QuestionDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestionDetailsState();
}

class _QuestionDetailsState extends ConsumerState<QuestionDetails> {
  final QuillEditorController bodyController = QuillEditorController();

  String questionId = '';
  bool isExpanded = false;
  bool isAnswer = false;
  bool isExit = false;
  int currentPage = 1;
  List<dynamic> relatedQuestions = [];
  List<dynamic> categoryQuestions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      questionId = args['id'] ?? '';
      isExit = args['isHide'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(topQuestionProvider(questionId));

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(topQuestionProvider(questionId));
        },
        child: asyncValue.when(
          data: (response) {
            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            final List<dynamic> questions = jsonResponse['data'];

            if (questions.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            final question = questions[0];
            final answers = question['answers'] as List<dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionHeader(question),
                  const SizedBox(height: 12),
                  HtmlWidget(question['body']),
                  const SizedBox(height: 12),
                  _buildInteractionSection(question),
                  const SizedBox(height: 12),
                  _buildAnswersSection(answers, question['name']),
                  if (!isAnswer)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        onTap: () {
                          setState(() {
                            isAnswer = !isAnswer;
                          });
                        },
                        icon: const Icon(
                          Icons.post_add,
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Post Your Answer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  if (isAnswer)
                    _buildCard(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: ToolBar(
                              controller: bodyController,
                            ),
                          ),
                          const SizedBox(height: 8),
                          QuillHtmlEditor(
                            hintText: 'Type your question details here...',
                            controller: bodyController,
                            isEnabled: true,
                            minHeight: 300,
                            hintTextAlign: TextAlign.start,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            hintTextPadding: EdgeInsets.zero,
                            loadingBuilder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 0.4,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  if (isAnswer)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        onTap: () async {
                          String answerText = await bodyController.getText();
                          await ref.refresh(postAnswerProvider({
                            'id': question['id'],
                            'answer': answerText,
                          }));
                        },
                        icon: const Icon(
                          Icons.post_add,
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Post Your Answer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                        onTap: () async {
                          final response = await ref.read(
                              relatedQuestionProvider(question['id']).future);
                          final Map<String, dynamic> relatedJson =
                              jsonDecode(response.body);
                          setState(() {
                            relatedQuestions = relatedJson['data'];
                          });
                        },
                        icon: const Icon(Icons.read_more, color: Colors.white),
                        child: const Text(
                          'View Related Questions',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const SizedBox(height: 12),
                  if (relatedQuestions.isNotEmpty)
                    RelatedQuestionsSection(relatedQuestions: relatedQuestions),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildCard({String? subTitle, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subTitle != null)
              Text(
                subTitle,
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(Map<String, dynamic> question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['title'],
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        isExit
            ? SizedBox()
            : CustomButton(
                onTap: () async {
                  final response = await ref.read(categoryQuestionProvider({
                    'id': question['category_id'],
                    'page': currentPage.toString()
                  }).future);
                  final Map<String, dynamic> relatedJson =
                      jsonDecode(response.body);
                  setState(() {
                    categoryQuestions = relatedJson['data'];
                  });
                  print(categoryQuestions);
                  if (categoryQuestions.isNotEmpty) {
                    await Navigator.pushNamed(context, '/homeCategoryScreen',
                        arguments: categoryQuestions);
                    print("Navigated to Category Screen"); // Debug print
                  } else {
                    print("No questions found"); // Debug print
                  }
                },
                child: Text(
                  question['category'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              question['tags'],
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
                children: [
                  const TextSpan(
                      text: 'By ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: question['name'],
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractionSection(Map<String, dynamic> question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.thumb_up_alt_outlined)),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(question['votes'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.thumb_down_alt_outlined)),
      ],
    );
  }

  Widget _buildAnswersSection(List<dynamic> answers, String questionName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('All Answers: ${answers.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        if (answers.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: answers.length,
            itemBuilder: (context, index) {
              final answer = answers[index];
              final comments = answer['comments'] as List<dynamic>;
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Answer by: ${answer['user_id']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      HtmlWidget(answer['answer'] ?? 'No answer provided',
                          textStyle: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('Posted on: ${answer['date']}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 12),
                      CommentsSection(comments: comments),
                      const SizedBox(height: 12),
                      CustomButton(
                        onTap: () {},
                        icon: const Icon(Icons.reply, color: Colors.white),
                        child: Text(
                          'Reply to $questionName',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        if (answers.isEmpty)
          const Text('No answers yet.', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
