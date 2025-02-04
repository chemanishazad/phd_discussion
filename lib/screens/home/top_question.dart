import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/home/widgets/info_card.dart';

class TopQuestion extends ConsumerStatefulWidget {
  const TopQuestion({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopQuestionState();
}

class _TopQuestionState extends ConsumerState<TopQuestion> {
  @override
  Widget build(BuildContext context) {
    const String questionId = '';
    final asyncValue = ref.watch(topQuestionProvider(questionId));
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Palette.themeColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(topQuestionProvider(questionId));
        },
        child: asyncValue.when(
          data: (response) {
            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            final List<dynamic> questions = jsonResponse['data'];

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 4),
                  ...questions.map((questionData) => GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/questionDetails',
                              arguments: {
                                'id': questionData['id'],
                                'isHide': false,
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Container(
                            decoration: cardDecoration(
                              context: context,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    questionData['title'],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                      applyHeightToFirstAscent: false,
                                      applyHeightToLastDescent: false,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${questionData['date']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textHeightBehavior:
                                              const TextHeightBehavior(
                                            applyHeightToFirstAscent: false,
                                            applyHeightToLastDescent: false,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final response = await ref.read(
                                            categoryQuestionProvider({
                                              'id': questionData['category_id'],
                                              'page': '1',
                                            }).future,
                                          );
                                          final Map<String, dynamic>
                                              relatedJson =
                                              jsonDecode(response.body);
                                          final categoryQuestions =
                                              relatedJson['data'] ?? [];

                                          if (categoryQuestions.isNotEmpty) {
                                            await Navigator.pushNamed(
                                              context,
                                              '/homeCategoryScreen',
                                              arguments: categoryQuestions,
                                            );
                                          } else {
                                            print("No questions found");
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2.0,
                                            horizontal: 6.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Palette.themeColor),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 2.0,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            questionData['category'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Palette.themeColor,
                                                ),
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                              applyHeightToFirstAscent: false,
                                              applyHeightToLastDescent: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InfoCard(
                                          icon: Icons.visibility,
                                          label: questionData['views']),
                                      InfoCard(
                                          icon: Icons.how_to_vote,
                                          label: questionData['votes']),
                                      InfoCard(
                                          icon: Icons.comment,
                                          label: questionData['answers']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 4),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}',
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(topQuestionProvider(questionId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
