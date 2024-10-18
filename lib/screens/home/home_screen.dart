import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
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
    final authState = ref.watch(authProvider);

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Container(
        color: Colors.black12,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Palette.themeColor,
              actions: [
                authState.when(
                  data: (user) {
                    return IconButton(
                      icon: user != null
                          ? const Icon(Icons.logout)
                          : const Icon(Icons.login),
                      onPressed: () async {
                        if (user != null) {
                          await ref.read(authProvider.notifier).logout();
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ],
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
            body: asyncValue.when(
              data: (response) {
                final Map<String, dynamic> jsonResponse =
                    jsonDecode(response.body);
                final List<dynamic> questions = jsonResponse['data'];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...questions.map((questionData) => GestureDetector(
                            onTap: () {
                              // print(questionData['category_id']);
                              Navigator.pushNamed(context, '/questionDetails',
                                  arguments: {
                                    'id': questionData['id'],
                                    'isHide': false,
                                    // 'user': questionData['likes']
                                  });
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      questionData['title'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text('${questionData['date']}',
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final response = await ref
                                                .read(categoryQuestionProvider({
                                              'id': questionData['category_id'],
                                              'page': '1',
                                            }).future);
                                            final Map<String, dynamic>
                                                relatedJson =
                                                jsonDecode(response.body);
                                            final categoryQuestions =
                                                relatedJson['data'] ?? [];

                                            if (categoryQuestions.isNotEmpty) {
                                              await Navigator.pushNamed(context,
                                                  '/homeCategoryScreen',
                                                  arguments: categoryQuestions);
                                            } else {
                                              print("No questions found");
                                            }
                                          },
                                          child: Text(
                                            questionData['category'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Palette.themeColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
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
                          )),
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
        Icon(icon, color: Palette.themeColor),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
