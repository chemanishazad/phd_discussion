import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/core/theme/font/font_sizer.dart';
import 'package:phd_discussion/core/theme/font/font_slider_model.dart';
import 'package:phd_discussion/core/theme/theme_provider.dart';
import 'package:phd_discussion/models/auth/userModel.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomMenu extends ConsumerWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Theme Toggle Button

          // Header Section
          _buildHeader(authState, context),

          // Divider
          const Divider(thickness: 1),

          // Menu List
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSection(
                  context: context,
                  title: "General",
                  items: [
                    _buildMenuItem(Icons.question_answer, "Ask a Question",
                        context, '/askQuestion', ref),
                    _buildMenuItem(Icons.help_outline, "Need Help", context,
                        '/helpScreen', ref),
                    _buildMenuItem(Icons.category, "Categories", context,
                        '/categories', ref),
                    _buildMenuItem(
                        Icons.info, "About Us", context, '/about', ref),
                  ],
                ),
                if (authState.value != null)
                  _buildSection(
                    context: context,
                    title: "Profile / Activity",
                    items: [
                      _buildMenuItem(Icons.account_circle, "Profile", context,
                          '/profileScreen', ref),
                      _buildMenuItem(Icons.question_answer, "My Questions",
                          context, '/myQuestionScreen', ref),
                      _buildMenuItem(Icons.question_answer_outlined,
                          "My Answers", context, '/myAnswerScreen', ref),
                      _buildMenuItem(Icons.favorite, "My Favourites", context,
                          '/myFavouriteScreen', ref),
                      _buildMenuItem(Icons.thumb_up_alt, "My Votes", context,
                          '/myVoteScreen', ref),
                      _buildMenuItem(Icons.settings, "Settings", context,
                          '/settingScreen', ref),
                    ],
                  ),
                SwitchListTile(
                  title: Text("Dark Mode",
                      style: Theme.of(context).textTheme.titleMedium),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) async {
                    await ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
                Text("Adjust Font Size",
                    style: Theme.of(context).textTheme.titleLarge),
                FontSizeSlider(),
                if (authState.value != null)
                  _buildLogout(Icons.logout, "Logout", context, ref),
              ],
            ),
          ),

          // Footer Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(thickness: 1),
                Text(
                  "Powered by ELK ❤",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Widget
  Widget _buildHeader(AsyncValue<UserModel?> authState, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16),
      child: Column(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: authState.when(
              data: (user) => user != null
                  ? Text(
                      user.name[0].toUpperCase(),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Palette.themeColor,
                                fontWeight: FontWeight.bold,
                              ),
                    )
                  : const Icon(Icons.person, size: 40, color: Colors.grey),
              loading: () => const CircularProgressIndicator(),
              error: (e, stack) => const Icon(Icons.error, color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),

          // Welcome Message or Login Button
          authState.when(
            data: (user) {
              if (user != null) {
                return Text(
                  "Welcome, ${user.name}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                );
              } else {
                return ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Palette.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Login"),
                );
              }
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, stack) => const Text("Error"),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required BuildContext context,
      required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context,
      String route, WidgetRef ref) {
    // Watch the current font size from the provider
    final fontSize = ref.watch(fontSizeProvider);

    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: fontSize, // Apply dynamic font size
            ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildLogout(
      IconData icon, String title, BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(icon, color: Palette.iconColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => _showLogoutDialog(context, () async {
        await ref.read(authProvider.notifier).logout();
      }),
    );
  }
}

Future<void> _showLogoutDialog(
    BuildContext context, Function logoutFunction) async {
  bool? shouldLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you really want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    logoutFunction();
  }
}
