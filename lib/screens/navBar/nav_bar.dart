import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phd_discussion/models/auth/userModel.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';

class CustomMenu extends ConsumerWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Simplified Header Section
            _buildHeader(authState, context),
            SizedBox(height: 8),
            // Menu List
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildSection(
                  context: context,
                  title: "General",
                  items: [
                    _buildMenuItem(Icons.question_answer, "Ask a Question",
                        context, '/askQuestion',
                        authState: authState),
                    _buildMenuItem(
                        Icons.help_outline, "Need Help", context, '/helpScreen',
                        authState: authState, requiresAuth: true),
                    _buildMenuItem(
                        Icons.category, "Categories", context, '/categories',
                        authState: authState),
                    _buildMenuItem(Icons.info, "About Us", context, '/about',
                        authState: authState),
                  ],
                ),
                _buildSection(
                  context: context,
                  title: "Profile / Activity",
                  items: [
                    _buildMenuItem(Icons.account_circle, "Profile", context,
                        '/profileScreen',
                        authState: authState, requiresAuth: true),
                    _buildMenuItem(Icons.question_answer, "My Questions",
                        context, '/myQuestionScreen',
                        authState: authState, requiresAuth: true),
                    _buildMenuItem(Icons.question_answer_outlined, "My Answers",
                        context, '/myAnswerScreen',
                        authState: authState, requiresAuth: true),
                    _buildMenuItem(Icons.favorite, "My Favourites", context,
                        '/myFavouriteScreen',
                        authState: authState, requiresAuth: true),
                    _buildMenuItem(Icons.thumb_up_alt, "My Votes", context,
                        '/myVoteScreen',
                        authState: authState, requiresAuth: true),
                    _buildMenuItem(
                        Icons.settings, "Settings", context, '/settingScreen',
                        authState: authState, requiresAuth: false),
                  ],
                ),
                if (authState.value != null)
                  _buildLogout(Icons.logout, "Logout", context, ref),
              ],
            ),

            // Footer Section
            
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue<UserModel?> authState, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(16),
      child: authState.when(
        data: (user) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                user != null
                    ? "Welcome back, ${user.name}!"
                    : "Welcome to Our Community!",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                user != null
                    ? "Discover new discussions and connect with others."
                    : "Sign in to ask questions, share answers, and explore!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (user == null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Login",
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (e, stack) => const Center(
          child: Icon(Icons.error, color: Colors.red, size: 32),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required BuildContext context,
    required List<Widget> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    BuildContext context,
    String route, {
    required AsyncValue<UserModel?> authState,
    bool requiresAuth = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          if (requiresAuth && authState.value == null)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.lock, size: 16, color: Colors.grey),
            ),
        ],
      ),
      onTap: () {
        if (requiresAuth && authState.value == null) {
          showToastWithAction(context, title);
        } else {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void showToastWithAction(BuildContext context, String title) {
    Fluttertoast.showToast(
      msg: 'You need to be logged in to access "$title".',
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Widget _buildLogout(
      IconData icon, String title, BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(icon),
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
        title: const Text('Are you sure?'),
        content: const Text('Do you really want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    logoutFunction();
  }
}
