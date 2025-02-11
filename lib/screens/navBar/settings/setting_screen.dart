import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/theme/font/font_slider_model.dart';
import 'package:phd_discussion/core/theme/theme_provider.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:reactive_forms/reactive_forms.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

final changePasswordProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await changePassword(params['password']!);
});
final updateEmailNotificationProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await updateEmailNotification(params['value']!);
});

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool isEmailNotification = false;
  bool isPassword = true;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  final FormGroup form = FormGroup({
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
    'confirmPassword': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh the profileProvider
    ref.refresh(profileProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    // Check if the user is logged in
    final bool isLoggedIn = authState.asData?.value != null;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(profileProvider);
          ref.refresh(authProvider);
        },
        child: !isLoggedIn
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    _buildSectionHeader("Preferences"),
                    _buildLoginPrompt("Email Notifications"),
                    _buildSectionHeader("Account Security"),
                    _buildLoginPrompt("Change Your Password"),
                    _buildSectionHeader("Appearance"),
                    SwitchListTile(
                      title: const Text("Dark Mode"),
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) async {
                        await ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                    const SizedBox(height: 10),
                    FontSizeSlider(),
                  ],
                ),
              )
            : profileAsyncValue.when(
                data: (profileData) {
                  // Safely update the email notification toggle
                  if (profileData['email_notification'] != null) {
                    isEmailNotification = profileData['email_notification']
                            ['email_notification'] ==
                        "1";
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Preferences Section
                          _buildSectionHeader("Preferences"),
                          ListTile(
                              title: const Text('Email Notifications'),
                              trailing: Switch(
                                value: isEmailNotification,
                                onChanged: (bool value) async {
                                  try {
                                    final response = await ref
                                        .read(updateEmailNotificationProvider({
                                      'value': isEmailNotification ? '0' : '1',
                                    }).future);

                                    final Map<String, dynamic> jsonResponse =
                                        jsonDecode(response.body);
                                    if (response.statusCode == 200) {
                                      ref.refresh(profileProvider);
                                      Fluttertoast.showToast(
                                          msg: jsonResponse['message']);
                                      setState(() {
                                        isEmailNotification = value;
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Error: ${response.reasonPhrase}');
                                    }
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: 'An error occurred: $e');
                                  }
                                },
                              )),
                          const Divider(),

                          // Account Security Section
                          _buildSectionHeader("Account Security"),
                          ListTile(
                            title: const Text("Change Password"),
                            trailing: IconButton(
                              icon: const Icon(Icons.lock_reset),
                              onPressed: () {
                                setState(() {
                                  isPassword = true;
                                });
                              },
                            ),
                          ),
                          if (isPassword && isLoggedIn)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: _buildChangePasswordForm(),
                            ),
                          const Divider(),

                          // Appearance Section
                          _buildSectionHeader("Appearance"),
                          SwitchListTile(
                            title: const Text("Dark Mode"),
                            value: themeMode == ThemeMode.dark,
                            onChanged: (value) async {
                              await ref
                                  .read(themeProvider.notifier)
                                  .toggleTheme();
                            },
                          ),
                          const SizedBox(height: 10),
                          FontSizeSlider(),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('An error occurred: $error'),
                ),
              ),
      ),
    );
  }

  // Helper Method: Section Headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  // Helper Method: Change Password Form
  Widget _buildChangePasswordForm() {
    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          CustomReactiveTextField(
            formControlName: 'password',
            hintText: 'New Password',
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword,
            onSuffixIconPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            validationMessages: {
              'required': (control) => 'The password is required',
              'minLength': (control) =>
                  'Password must be at least 6 characters',
            },
          ),
          const SizedBox(height: 10),
          CustomReactiveTextField(
            formControlName: 'confirmPassword',
            hintText: 'Confirm Password',
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword2,
            onSuffixIconPressed: () {
              setState(() {
                _obscurePassword2 = !_obscurePassword2;
              });
            },
            validationMessages: {
              'required': (control) => 'The password is required',
              'minLength': (control) =>
                  'Password must be at least 6 characters',
            },
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              onTap: () async {
                form.markAllAsTouched();
                if (form.valid) {
                  if (form.control('password').value !=
                      form.control('confirmPassword').value) {
                    Fluttertoast.showToast(msg: 'Passwords do not match!');
                  } else {
                    try {
                      final response = await ref.read(changePasswordProvider({
                        'password': form.control('password').value,
                      }).future);

                      final Map<String, dynamic> jsonResponse =
                          jsonDecode(response.body);
                      if (response.statusCode == 200) {
                        ref.refresh(profileProvider);
                        Fluttertoast.showToast(msg: jsonResponse['message']);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Error: ${response.reasonPhrase}');
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'An error occurred: $e');
                    }
                  }
                }
              },
              child: const Text(
                "Change Password",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Method: Login Prompt
  Widget _buildLoginPrompt(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium)),
        CustomButton(
          onTap: () {
            Navigator.pushNamed(context, '/login',
                arguments: {'title': 'withoutLogin'});
          },
          child: Text(
            " Login to Enable ",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white),
            maxLines: null,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
