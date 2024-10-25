import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/models/auth/userModel.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomMenu extends ConsumerWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTags = ref.watch(tagProvider);
    final authState = ref.watch(authProvider);

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: <Widget>[
            _buildHeader(authState, context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildExpansionTile(
                    title: 'General',
                    children: [
                      _buildMenuItem(Icons.question_answer, 'Ask a Question',
                          context, '/askQuestion'),
                      ListTile(
                        leading:
                            const Icon(Icons.help, color: Palette.iconColor),
                        title: const Text('Need Help',
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          _navigateToHelp(context, authState);
                        },
                      ),
                      _buildMenuItem(
                          Icons.category, 'Categories', context, '/categories'),
                      _buildMenuItem(Icons.info, 'About Us', context, '/about'),
                    ],
                  ),
                  _buildExpansionTile(
                    title: 'Related Tags',
                    children: [
                      _buildMenuItem(Icons.school, 'PhD Admission', context,
                          '/phdAdmission'),
                      _buildMenuItem(Icons.search, 'Action Research', context,
                          '/phdAdmission'),
                      _buildMenuItem(
                          Icons.article, 'APA Style', context, '/phdAdmission'),
                      _buildMenuItem(Icons.library_books, 'Annexure I Journals',
                          context, '/phdAdmission'),
                      _buildMenuItem(Icons.edit, 'Academic Writing', context,
                          '/phdAdmission'),
                    ],
                  ),
                  if (authState.value != null) ...[
                    _buildExpansionTile(
                      title: 'Profile / Activity',
                      children: [
                        _buildMenuItem(Icons.account_circle_sharp, 'Profile',
                            context, '/profileScreen'),
                        // _buildMenuItem(Icons.article, 'Summary', context,
                        //     '/summaryScreen'),
                        _buildMenuItem(Icons.question_answer, 'My Question(s)',
                            context, '/myQuestionScreen'),
                        _buildMenuItem(Icons.question_answer_outlined,
                            'My Answer(s)', context, '/myAnswerScreen'),
                        _buildMenuItem(Icons.thumb_up, 'My Vote(s)', context,
                            '/myVoteScreen'),
                        _buildMenuItem(Icons.favorite, 'My Favourite(s)',
                            context, '/myFavouriteScreen'),
                        _buildMenuItem(Icons.settings, 'Settings', context,
                            '/settingScreen'),
                      ],
                    ),
                  ],
                  _buildExpansionTile(
                    title: 'Various Subjects',
                    children: [
                      if (asyncTags.hasValue)
                        ...asyncTags.value!.map((tag) {
                          return ListTile(
                            leading:
                                const Icon(Icons.tag, color: Palette.iconColor),
                            title: Text(tag.brand,
                                style: const TextStyle(color: Colors.black)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/tagDetails',
                                  arguments: tag.id);
                            },
                          );
                        }),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Powered by ELK ❤',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue<UserModel?> authState, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          color: Palette.themeColor,
          child: Column(
            children: [
              SizedBox(height: 5.h),
              authState.when(
                data: (user) {
                  print(user?.authToken);
                  if (user != null) {
                    return TextButton(
                      onPressed: () {
                        print('user${user.authToken}');
                        Navigator.pushNamed(context, '/profileScreen');
                      },
                      child: Text(
                        'Welcome, ${user.name}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Palette.themeColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, stack) => const Text(
                  'Error loading user',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionTile(
      {required String title, required List<Widget> children}) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      ),
      children: children,
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, BuildContext context, String route) {
    return ListTile(
      leading: Icon(icon, color: Palette.iconColor),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  void _navigateToHelp(BuildContext context, AsyncValue<UserModel?> authState) {
    Navigator.pop(context);
    authState.when(
      data: (user) {
        if (user != null) {
          Navigator.pushNamed(context, '/helpScreen');
        } else {
          Navigator.pushNamed(context, '/login', arguments: {
            'title':
                'Login to ask more relevant questions or answer questions on PhD discussions.'
          });
        }
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    );
  }
}
