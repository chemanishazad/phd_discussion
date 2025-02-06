import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';

class QuestionListWidget extends ConsumerWidget {
  final AsyncValue<Response> asyncValue;
  final Function onQuestionTap;

  const QuestionListWidget({
    required this.asyncValue,
    required this.onQuestionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: asyncValue.when(
        data: (response) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          final List<dynamic> questions = jsonResponse['data'];
          final List<dynamic> limitedQuestions = questions.take(5).toList();

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: limitedQuestions.length,
                itemBuilder: (context, index) {
                  final questionData = limitedQuestions[index];
                  return GestureDetector(
                    onTap: () {
                      onQuestionTap(context, questionData);
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: cardDecoration(context: context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              questionData['title'],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${questionData['date']}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                      applyHeightToFirstAscent: false,
                                      applyHeightToLastDescent: false,
                                    ),
                                  ),
                                ),
                                CategoryButton(
                                  categoryId: questionData['category_id'],
                                  categoryName: questionData['category'],
                                  ref: ref,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
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
                  ref.refresh(topQuestionProvider('questionId'));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends ConsumerWidget {
  final String categoryId;
  final String categoryName;
  final WidgetRef ref;

  const CategoryButton({
    required this.categoryId,
    required this.categoryName,
    required this.ref,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final response = await ref.read(categoryQuestionProvider({
          'id': categoryId,
          'page': '1',
        }).future);
        final Map<String, dynamic> relatedJson = jsonDecode(response.body);
        final categoryQuestions = relatedJson['data'] ?? [];

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
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Palette.themeColor),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          categoryName,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Palette.themeColor),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
    );
  }
}
