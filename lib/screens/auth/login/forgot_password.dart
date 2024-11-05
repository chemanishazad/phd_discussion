import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/homeProvider/homeProvider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final forgotPasswordProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await forgotPassword(params['email']!);
});

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final FormGroup form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
  });
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.white, Palette.themeColor],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            child: ReactiveForm(
              formGroup: form,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h),
                    Image.asset('assets/icons/logo2.png'),
                    SizedBox(height: 2.h),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Palette.themeColor,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Enter your email to reset your password',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.h),
                    CustomReactiveTextField(
                      formControlName: 'email',
                      hintText: 'Email',
                      prefixIcon: Icons.person,
                      validationMessages: {
                        'required': (control) => 'The email is required',
                        'email': (control) => 'Please enter a valid email',
                      },
                    ),
                    SizedBox(height: 4.h),
                    message.isNotEmpty
                        ? Text(message)
                        : CustomButton(
                            onTap: () async {
                              if (form.valid) {
                                final response =
                                    await ref.read(forgotPasswordProvider({
                                  'email': form.control('email').value,
                                }).future);

                                final Map<String, dynamic> jsonResponse =
                                    jsonDecode(response.body);
                                if (response.statusCode == 200 &&
                                    jsonResponse['status'] == true) {
                                  setState(() {
                                    message = jsonResponse['message'];
                                  });
                                  Fluttertoast.showToast(
                                      msg: jsonResponse['message']);
                                } else if (jsonResponse['status'] != true) {
                                  Fluttertoast.showToast(
                                      msg: jsonResponse['message']);
                                }
                              } else {
                                form.markAllAsTouched();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please enter a valid email')),
                                );
                              }
                            },
                            child: const Text('Send Reset Link',
                                style: TextStyle(color: Colors.white)),
                          ),
                    SizedBox(height: 2.h),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Back to Login'),
                    ),
                    SizedBox(height: 5.h),
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
