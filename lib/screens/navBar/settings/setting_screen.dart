import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  bool isPassword = false;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;
  final FormGroup form = FormGroup({
    'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)]),
    'confirmPassword': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)]),
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Setting'),
      body: profileAsyncValue.when(
        data: (profileData) {
          if (profileData['email_notification'] != null) {
            isEmailNotification =
                profileData['email_notification']['email_notification'] == "1";
          }

          return ReactiveForm(
            formGroup: form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Email Notifications: '),
                        Switch(
                          value: isEmailNotification,
                          onChanged: (bool value) async {
                            final response =
                                await ref.read(updateEmailNotificationProvider({
                              'value': isEmailNotification == true ? '0' : '1',
                            }).future);
                            final Map<String, dynamic> jsonResponse =
                                jsonDecode(response.body);
                            if (response.statusCode == 200) {
                              ref.refresh(profileProvider);
                              Fluttertoast.showToast(
                                  msg: jsonResponse['message']);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'Error voting: ${response.reasonPhrase}');
                            }

                            setState(() {
                              isEmailNotification = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    child: const Text(' Change Password'),
                    onPressed: () {
                      setState(() {
                        isPassword = true;
                      });
                    },
                  ),
                  if (isPassword) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CustomReactiveTextField(
                        formControlName: 'password',
                        hintText: 'Password',
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
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CustomReactiveTextField(
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
                    ),
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CustomButton(
                          onTap: () async {
                            form.markAllAsTouched();
                            if (form.valid) {
                              if (form.control('password').value !=
                                  form.control('confirmPassword').value) {
                                Fluttertoast.showToast(
                                    msg: 'Please Check Entered Password');
                              } else {
                                final response =
                                    await ref.read(changePasswordProvider({
                                  'password': form.control('password').value,
                                }).future);
                                final Map<String, dynamic> jsonResponse =
                                    jsonDecode(response.body);
                                if (response.statusCode == 200) {
                                  ref.refresh(profileProvider);
                                  Fluttertoast.showToast(
                                      msg: jsonResponse['message']);

                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Error voting: ${response.reasonPhrase}');
                                }
                              }
                            }
                          },
                          child: const Text(
                            'Change Your Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 2.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CustomButton(
                        onTap: () async {
                          await ref.read(authProvider.notifier).logout();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
