import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String questionId = '';
    final asyncValue = ref.watch(topQuestionProvider(questionId));

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Container(
        color: Colors.black12,
        child: SafeArea(
          child: Scaffold(
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
            ),
            drawer: const CustomMenu(),
            body: RefreshIndicator(
              onRefresh: () async {
                ref.refresh(topQuestionProvider(questionId));
              },
              child: asyncValue.when(
                data: (response) {
                  final Map<String, dynamic> jsonResponse =
                      jsonDecode(response.body);
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
                                    padding: const EdgeInsets.all(
                                        8.0), // Keep minimal padding around the content
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize
                                          .min, // Prevent extra vertical space in Column
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
                                          ), // Reduce inherent line height
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
                                                  applyHeightToFirstAscent:
                                                      false,
                                                  applyHeightToLastDescent:
                                                      false,
                                                ), // Reduce inherent line height
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
                                                    arguments:
                                                        categoryQuestions,
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
                                                ), // Compact padding
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Palette.themeColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
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
                                                        color:
                                                            Palette.themeColor,
                                                      ),
                                                  textHeightBehavior:
                                                      const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false,
                                                    applyHeightToLastDescent:
                                                        false,
                                                  ), // Reduce inherent line height
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _InfoCard(
                                                icon: Icons.visibility,
                                                label: questionData['views']),
                                            _InfoCard(
                                                icon: Icons.how_to_vote,
                                                label: questionData['votes']),
                                            _InfoCard(
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
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoCard({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
