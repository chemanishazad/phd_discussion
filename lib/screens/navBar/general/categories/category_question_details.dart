import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'dart:convert';

class CategoryQuestion extends ConsumerStatefulWidget {
  const CategoryQuestion({super.key});

  @override
  ConsumerState<CategoryQuestion> createState() => _CategoryQuestionState();
}

class _CategoryQuestionState extends ConsumerState<CategoryQuestion> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  bool isLoading = false;
  bool hasLoadedInitial = false; // Track initial load state
  List<dynamic> categoryQuestions = [];
  String? categoryId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreQuestions();
    }
  }

  Future<void> loadMoreQuestions() async {
    if (isLoading || categoryId == null) return;

    setState(() {
      isLoading = true;
      currentPage++;
    });

    try {
      final response = await ref.read(categoryQuestionProvider({
        'id': categoryId!,
        'page': currentPage.toString(),
      }).future);

      final Map<String, dynamic> relatedJson = jsonDecode(response.body);

      if (relatedJson['status'] == true) {
        List<dynamic> questionsData = relatedJson['data'];

        if (questionsData.isNotEmpty) {
          setState(() {
            categoryQuestions.addAll(questionsData);
          });
        } else {
          // No more questions to load
          print('No more questions found on page $currentPage');
        }
      } else {
        print(relatedJson['message']);
      }
    } catch (e) {
      print('Error loading questions: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasLoadedInitial = true; // Mark initial load as complete
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String) {
      categoryId = args;
    }

    if (categoryId != null && categoryQuestions.isEmpty && !isLoading) {
      loadMoreQuestions();
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Category Details'),
      body: hasLoadedInitial
          ? categoryQuestions.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No questions available this category'),
                    SizedBox(
                      height: 8,
                    ),
                    CustomButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Try Different Category',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: categoryQuestions.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == categoryQuestions.length && isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final question = categoryQuestions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/questionDetails',
                            arguments: {
                              'id': question['id'],
                              'isHide': true,
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: Container(
                          decoration: cardDecoration(context: context),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(question['title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge),
                                const SizedBox(height: 10),
                                HtmlWidget(
                                  question['body'],
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 14),
                                    const SizedBox(width: 4),
                                    Text(question['date'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.remove_red_eye, size: 14),
                                    const SizedBox(width: 4),
                                    Text(question['views'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Palette.themeColor,
                                            child: Text(question['user_id'][0],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                        color: Colors.white)),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                                "Posted by: ${question['user_id']}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Icon(Icons.arrow_forward_ios,
                                          size: 20, color: Palette.themeColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
