import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/general/categories/categories_screen.dart';
import 'package:phd_discussion/screens/navBar/nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _printText() {
    print(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    const String questionId = '';
    final asyncValue = ref.watch(topQuestionProvider(questionId));
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Palette.themeColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: const Text(
            'PhD Discussion',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: const CustomMenu(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _printText,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Top Categories',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                categoriesAsyncValue.when(
                  data: (data) {
                    print(data);
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: data['categories'].map<Widget>((category) {
                          int childrenCount = category['children']?.length ?? 0;

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: cardDecoration(context: context),
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(category['category'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  SizedBox(height: 4),
                                  Text(
                                    '$childrenCount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
                const SizedBox(height: 8),
                Text(
                  'Top Questions For You',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                asyncValue.when(
                  data: (response) {
                    final Map<String, dynamic> jsonResponse =
                        jsonDecode(response.body);
                    final List<dynamic> questions = jsonResponse['data'];
                    final List<dynamic> limitedQuestions =
                        questions.take(5).toList();

                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: limitedQuestions.length,
                          itemBuilder: (context, index) {
                            final questionData = limitedQuestions[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/questionDetails',
                                    arguments: {
                                      'id': questionData['id'],
                                      'isHide': false,
                                    });
                              },
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: cardDecoration(context: context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        questionData['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
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
                                                  'id': questionData[
                                                      'category_id'],
                                                  'page': '1',
                                                }).future,
                                              );
                                              final Map<String, dynamic>
                                                  relatedJson =
                                                  jsonDecode(response.body);
                                              final categoryQuestions =
                                                  relatedJson['data'] ?? [];

                                              if (categoryQuestions
                                                  .isNotEmpty) {
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                  applyHeightToFirstAscent:
                                                      false,
                                                  applyHeightToLastDescent:
                                                      false,
                                                ),
                                              ),
                                            ),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                const SizedBox(height: 8),
                Text(
                  'Discover More',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
