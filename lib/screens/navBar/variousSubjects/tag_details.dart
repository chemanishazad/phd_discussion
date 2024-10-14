import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class TagDetails extends ConsumerStatefulWidget {
  const TagDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TagDetailsState();
}

class _TagDetailsState extends ConsumerState<TagDetails> {
  String? tagId;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoading = false;
  List<dynamic> tagQuestions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is String) {
      tagId = arguments;
      loadMoreQuestions(); // Load questions once tagId is set
    }
  }

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
    if (isLoading || tagId == null) return;

    setState(() {
      isLoading = true;
      currentPage++;
    });

    try {
      final response = await ref.read(tagQuestionProvider({
        'id': tagId!,
        'page': currentPage.toString(),
      }).future);

      if (response.body == null) {
        print('Response body is null');
        return;
      }

      final Map<String, dynamic> relatedJson = jsonDecode(response.body);

      if (relatedJson['status'] == true && relatedJson['data'] != null) {
        List<dynamic> questionsData = relatedJson['data'];
        print('Number of questions fetched: ${questionsData.length}');

        setState(() {
          tagQuestions.addAll(questionsData);
        });
      } else {
        print(relatedJson['message']);
      }
    } catch (e) {
      print('Error loading questions: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tag Details'),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            tagQuestions.clear(); // Clear previous questions
            currentPage = 1; // Reset page to 1
          });
          await loadMoreQuestions();
        },
        child: isLoading && tagQuestions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : tagQuestions.isEmpty
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        loadMoreQuestions();
                      },
                      child: const Text('No questions available'),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: tagQuestions.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == tagQuestions.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final question = tagQuestions[index];
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
                              vertical: 8.0, horizontal: 16.0),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.themeColor),
                                ),
                                const SizedBox(height: 10),
                                HtmlWidget(
                                  question['body'],
                                  textStyle: const TextStyle(
                                      fontSize: 15, color: Colors.black87),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(question['date'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.remove_red_eye,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(question['views'].toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
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
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 20, color: Palette.themeColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
