import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import 'widgets/comment_section.dart';
import 'widgets/related_question.dart';

final postVoteProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await postVote(params['id']!, params['vote']!);
});
final postAddVoteProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await postAddFav(params['id']!);
});
final postRemoveVoteProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await postRemoveFav(params['id']!);
});

final postCommentProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await postComment(
      params['id']!, params['answerId']!, params['answer']!);
});

class QuestionDetails extends ConsumerStatefulWidget {
  const QuestionDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestionDetailsState();
}

class _QuestionDetailsState extends ConsumerState<QuestionDetails> {
  final QuillEditorController bodyController = QuillEditorController();
  ScrollController _scrollController = ScrollController();

  String questionId = '';
  bool isExpanded = false;
  bool isAnswer = false;
  bool isExit = false;
  bool isRelated = false;
  int currentPage = 1;
  List<dynamic> like = [];
  List<dynamic> relatedQuestions = [];
  List<dynamic> categoryQuestions = [];
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.size,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

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
    final authState = ref.watch(authProvider);
    final user = authState.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

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
            setState(() {
              like = questions[0]['likes'] ?? [];
            });

            if (questions.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            final question = questions[0];
            final List<dynamic> answers = question['answers'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuestionHeader(question),
                  const SizedBox(height: 4),
                  HtmlWidget(question['body']),
                  _buildInteractionSection(question),
                  _buildAnswersSection(answers, question['name']),
                  const SizedBox(height: 6),
                  if (!isAnswer)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        onTap: () {
                          print(user?.name);

                          if (user?.name == null) {
                            showToastWithAction(context, 'Answer');
                          } else {
                            setState(() {
                              isAnswer = !isAnswer;
                            });
                          }
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
                  const SizedBox(height: 4),
                  if (isAnswer)
                    _buildCard(
                      child: Column(
                        children: [
                          Container(
                            child: ToolBar(
                              controller: bodyController,
                              toolBarConfig: customToolBarList,
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

                          if (user?.name == null || user!.name.isEmpty) {
                            showToastWithAction(context, 'Answer');
                          } else {
                            if (answerText.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Type Your Answer');
                              return;
                            }
                            try {
                              final response =
                                  await ref.read(postAnswerProvider({
                                'id': question['id'],
                                'answer': answerText,
                              }).future);

                              if (response.statusCode == 200) {
                                final Map<String, dynamic> jsonResponse =
                                    jsonDecode(response.body);

                                Fluttertoast.showToast(
                                    msg: jsonResponse['message']);
                                bodyController.clear();
                                setState(() {
                                  isAnswer = false;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Failed to post answer. Status code: ${response.statusCode}');
                              }
                            } catch (e) {
                              // Handle any exceptions
                              Fluttertoast.showToast(
                                  msg: 'Error: ${e.toString()}');
                            }
                          }
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
                  SizedBox(height: 4),
                  if (!isRelated)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                          onTap: () async {
                            final response = await ref.read(
                                relatedQuestionProvider(question['id']).future);
                            final Map<String, dynamic> relatedJson =
                                jsonDecode(response.body);
                            print('API Response: ${response.body}');

                            setState(() {
                              isRelated = true;
                              relatedQuestions = relatedJson['data'];
                            });
                          },
                          icon:
                              const Icon(Icons.read_more, color: Colors.white),
                          child: const Text(
                            'View Related Questions',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  const SizedBox(height: 12),
                  if (isRelated)
                    relatedQuestions.isNotEmpty
                        ? RelatedQuestionsSection(
                            relatedQuestions: relatedQuestions,
                            scrollController: _scrollController,
                          )
                        : const Center(
                            child: Text('No related questions found'),
                          ),
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
          style: Theme.of(context).textTheme.titleSmall,
        ),
        isExit
            ? const SizedBox()
            : ElevatedButton(
                onPressed: () async {
                  final response = await ref.read(categoryQuestionProvider({
                    'id': question['category_id'],
                    'page': currentPage.toString()
                  }).future);
                  final Map<String, dynamic> relatedJson =
                      jsonDecode(response.body);
                  setState(() {
                    categoryQuestions = relatedJson['data'];
                  });

                  if (categoryQuestions.isNotEmpty) {
                    await Navigator.pushNamed(context, '/homeCategoryScreen',
                        arguments: categoryQuestions);
                    print("Navigated to Category Screen");
                  } else {
                    print("No questions found");
                  }
                },
                child: Text(
                  question['category'],
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Palette.whiteColor),
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: boxDecoration(context: context),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                question['tags'],
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'By ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
        SizedBox(
          height: 4,
        )
      ],
    );
  }

  void showToastWithAction(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text('You need to be logged in to $title.'),
      action: SnackBarAction(
        label: 'Login',
        onPressed: () {
          Navigator.pushNamed(context, '/login',
              arguments: {'title': 'withoutLogin'});
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildInteractionSection(Map<String, dynamic> question) {
    final authState = ref.watch(authProvider);
    final user = authState.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    final bool isLiked = user != null &&
        question['likes'] != null &&
        question['likes'].contains(user.userId);
    final bool isFav = user != null &&
        question['favourites'] != null &&
        question['favourites'].contains(user.userId);

    print('user ${user?.userId}');
    print(isLiked);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              print('Posting vote for question_id: ${question['id']} ');

              if (user != null) {
                final response = await ref.read(postVoteProvider({
                  'id': question['id'],
                  'vote': isLiked ? '-1' : '1',
                }).future);

                final Map<String, dynamic> jsonResponse =
                    jsonDecode(response.body);
                if (response.statusCode == 200 &&
                    jsonResponse['success'] != null) {
                  await ref.refresh(topQuestionProvider(questionId));
                  Fluttertoast.showToast(msg: jsonResponse['success']);
                } else if (jsonResponse['error'] != null) {
                  await ref.refresh(topQuestionProvider(questionId));
                  Fluttertoast.showToast(msg: jsonResponse['error']);
                } else {
                  Fluttertoast.showToast(
                      msg: 'Error voting: ${response.reasonPhrase}');
                }
              } else {
                showToastWithAction(context, 'Vote');
                // Fluttertoast.showToast(
                //     msg: 'You need to be logged in to vote.');
              }
            },
            icon: Icon(
              isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
              color: isLiked ? Palette.themeColor : null,
            )),
        Container(
          decoration: cardDecoration(
            context: context,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(question['votes'].toString(),
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        IconButton(
            onPressed: () async {
              print('Posting vote for question_id: ${question['id']} ');

              if (user != null) {
                if (!isFav) {
                  final response = await ref.read(postAddVoteProvider({
                    'id': question['id'],
                  }).future);

                  final Map<String, dynamic> jsonResponse =
                      jsonDecode(response.body);
                  if (response.statusCode == 200 &&
                      jsonResponse['success'] != null) {
                    await ref.refresh(topQuestionProvider(questionId));
                    Fluttertoast.showToast(msg: jsonResponse['success']);
                  } else if (jsonResponse['error'] != null) {
                    await ref.refresh(topQuestionProvider(questionId));
                    Fluttertoast.showToast(msg: jsonResponse['error']);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Error voting: ${response.reasonPhrase}');
                  }
                } else {
                  final response = await ref.read(postRemoveVoteProvider({
                    'id': question['id'],
                  }).future);

                  final Map<String, dynamic> jsonResponse =
                      jsonDecode(response.body);
                  if (response.statusCode == 200 &&
                      jsonResponse['success'] != null) {
                    await ref.refresh(topQuestionProvider(questionId));
                    Fluttertoast.showToast(msg: jsonResponse['success']);
                  } else if (jsonResponse['error'] != null) {
                    await ref.refresh(topQuestionProvider(questionId));
                    Fluttertoast.showToast(msg: jsonResponse['error']);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Error voting: ${response.reasonPhrase}');
                  }
                }
              } else {
                showToastWithAction(context, 'Favourite');
              }
            },
            icon: Icon(isFav ? Icons.star : Icons.star_border,
                color: isFav ? Colors.amber[600] : null))
      ],
    );
  }

  Widget _buildAnswersSection(List<dynamic> answers, String questionName) {
    final authState = ref.watch(authProvider);
    final user = authState.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('All Answers: ${answers.length}',
            style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        if (answers.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: answers.length,
            itemBuilder: (context, index) {
              final answer = answers[index];
              final comments = answer['comments'] as List<dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: cardDecoration(
                    context: context,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Answer by: ${answer['user_id']}',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        HtmlWidget(answer['answer'] ?? 'No answer provided',
                            textStyle: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text('Posted on: ${answer['date']}',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 12),
                        CommentsSection(comments: comments),
                        const SizedBox(height: 12),
                        CustomButton(
                          onTap: () {
                            if (user != null) {
                              TextEditingController commentController =
                                  TextEditingController();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    title: Text(
                                      'Reply to ${answer['user_id']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    content: Container(
                                      width: double.maxFinite,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: commentController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Type your reply here...',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: const BorderSide(
                                                    color: Palette.themeColor),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                            ),
                                            maxLines: 5,
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.newline,
                                            onSubmitted: (value) {
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  String commentText =
                                                      commentController.text
                                                          .trim();
                                                  if (commentText.isNotEmpty) {
                                                    try {
                                                      final response =
                                                          await ref.read(
                                                              postCommentProvider({
                                                        'id': questionId,
                                                        'answerId':
                                                            answer['comments']
                                                                [index]['id'],
                                                        'answer': commentText,
                                                      }).future);

                                                      if (response.statusCode ==
                                                          200) {
                                                        final jsonResponse =
                                                            jsonDecode(
                                                                response.body);
                                                        Fluttertoast.showToast(
                                                            msg: jsonResponse[
                                                                'message']);
                                                        commentController
                                                            .clear();
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Failed to post comment.');
                                                      }
                                                    } catch (e) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Error posting comment: ${e.toString()}');
                                                      print(
                                                          'Error during posting comment: $e');
                                                    }
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please enter a reply.');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Palette.themeColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
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
                              showToastWithAction(context, 'Reply');
                            }
                          },
                          icon: const Icon(Icons.reply, color: Colors.white),
                          child: Text(
                            'Reply to ${answer['user_id']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
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
