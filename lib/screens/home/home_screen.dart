import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String questionId = '';
    final asyncValue = ref.watch(topQuestionProvider(questionId));

    return Container(
      color: Colors.black12,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Palette.themeColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () async {
                  Navigator.pushNamed(context, '/login');
                },
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

              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final questionData = questions[index];

                  return GestureDetector(
                    onTap: () {
                      print(questionData['id']);
                      Navigator.pushNamed(context, '/questionDetails',
                          arguments: {
                            'id': questionData['id'],
                            'isHide': false,
                          });
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questionData['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              questionData['body'].replaceAll(
                                  RegExp(r'<[^>]*>'), ''), // Strip HTML tags
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _InfoCard(
                                  icon: Icons.visibility,
                                  label: questionData['views'],
                                ),
                                _InfoCard(
                                  icon: Icons.thumb_up,
                                  label: questionData['votes'],
                                ),
                                _InfoCard(
                                  icon: Icons.comment,
                                  label: questionData['answers'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
