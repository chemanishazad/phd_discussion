import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'dart:convert';

class HomeCategoryScreen extends ConsumerStatefulWidget {
  const HomeCategoryScreen({super.key});

  @override
  ConsumerState<HomeCategoryScreen> createState() => _HomeCategoryScreenState();
}

class _HomeCategoryScreenState extends ConsumerState<HomeCategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoading = false;
  List<dynamic> categoryQuestions = [];

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
    if (isLoading) return;

    setState(() {
      isLoading = true;
      currentPage++;
    });

    try {
      final response = await ref.read(categoryQuestionProvider({
        'id': '4',
        'page': currentPage.toString(),
      }).future);

      final Map<String, dynamic> relatedJson = jsonDecode(response.body);

      if (relatedJson['status'] == true) {
        List<dynamic> questionsData = relatedJson['data'];

        setState(() {
          categoryQuestions.addAll(questionsData);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print(relatedJson['message']);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;

    if (args != null) {
      categoryQuestions = args;
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Category Details'),
      body: categoryQuestions.isEmpty
          ? const Center(child: Text('No questions available'))
          : ListView.builder(
              controller: _scrollController,
              itemCount: categoryQuestions.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == categoryQuestions.length) {
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
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['title'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.themeColor),
                          ),
                          const SizedBox(height: 10),
                          HtmlWidget(
                            question['body'],
                            textStyle: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(question['date'],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                              const SizedBox(width: 16),
                              const Icon(Icons.remove_red_eye,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(question['views'].toString(),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Palette.themeColor,
                                      child: Text(question['user_id'][0],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                          "Posted by: ${question['user_id']}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54)),
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
                );
              },
            ),
    );
  }
}
