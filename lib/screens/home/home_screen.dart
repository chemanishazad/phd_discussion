import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:phd_discussion/screens/navBar/general/categories/categories_screen.dart';
import 'package:phd_discussion/screens/navBar/nav_bar.dart';
import 'widgets/home_askquestion.dart';
import 'widgets/home_category.dart';
import 'widgets/home_question.dart';
import 'widgets/home_tag.dart';

final List<Map<String, dynamic>> tags = [
  {"icon": Icons.code, "name": "Programming", "count": 120},
  {"icon": Icons.science, "name": "Research", "count": 98},
  {"icon": Icons.language, "name": "Linguistics", "count": 75},
  {"icon": Icons.history_edu, "name": "History", "count": 88},
  {"icon": Icons.psychology, "name": "Psychology", "count": 60},
];

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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x66D0E8FF),
                Color(0xE6B3D9FF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                        onPressed: _printText,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Categories',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/categories');
                          },
                          child: Text('View All'))
                    ],
                  ),
                ),
                CategoryListWidget(categoriesAsyncValue: categoriesAsyncValue),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Questions For You',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/topQuestion');
                          },
                          child: Text('View All'))
                    ],
                  ),
                ),
                QuestionListWidget(
                  asyncValue: asyncValue,
                  onQuestionTap: (context, questionData) {
                    Navigator.pushNamed(
                      context,
                      '/questionDetails',
                      arguments: {
                        'id': questionData['id'],
                        'isHide': false,
                      },
                    );
                  },
                ),
                HomeAskQuestion(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Most used tags',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: tags.map((tag) {
                      return TagCard(
                        icon: tag["icon"],
                        tagName: tag["name"],
                        tagCount: tag["count"],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "Didn't Find Anything Useful? Talk to us",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 8),
                const CallCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CallCard extends StatelessWidget {
  const CallCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Container(
        decoration: cardDecoration(context: context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join a 30-minute session to share feedback and ask questions',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/scheduleCall');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Schedule a call',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, color: Colors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.phone, size: 40, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
