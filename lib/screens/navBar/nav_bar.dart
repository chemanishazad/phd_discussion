import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomMenu extends ConsumerWidget {
  const CustomMenu({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTags = ref.watch(tagProvider);

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildSectionTitle('General'),
                  _buildMenuItem(Icons.question_answer, 'Ask a Question',
                      context, '/askQuestion'),
                  _buildMenuItem(Icons.help, 'Need Help', context, '/login'),
                  _buildMenuItem(
                      Icons.category, 'Categories', context, '/categories'),
                  _buildMenuItem(Icons.info, 'About Us', context, '/about'),
                  const Divider(),
                  _buildSectionTitle('Related Tags'),
                  _buildMenuItem(
                      Icons.book, 'PhD Admission', context, '/phdAdmission'),
                  _buildMenuItem(Icons.book, 'Action Research', context, ''),
                  _buildMenuItem(Icons.book, 'APA Style', context, ''),
                  _buildMenuItem(
                      Icons.book, 'Annexure I Journals', context, ''),
                  _buildMenuItem(Icons.book, 'Academic Writing', context, ''),
                  const Divider(),
                  _buildSectionTitle('Various Subjects'),
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
                  const Divider(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Powered by Your App',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          color: Palette.themeColor,
          child: Column(
            children: [
              SizedBox(height: 5.h),
              const Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        ),
      ),
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
}
