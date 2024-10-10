import 'package:flutter/material.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/components/reactive_dropdown.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SigUupScreenState();
}

class _SigUupScreenState extends State<SignUpScreen> {
  final FormGroup form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
    'confirmPassword': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
    'mobile': FormControl<String>(),
    'role': FormControl<String>(validators: [Validators.required]),
  });

  bool isLoading = false;
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.lightBackgroundColor,
        body: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipPath(
                      child: Container(
                        height: 20.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.white,
                              Color.fromARGB(255, 181, 232, 255),
                              Color.fromARGB(255, 30, 178, 247),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(140),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12.0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.h,
                      child: Image.asset(
                        'assets/icons/logo2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
                        formControlName: 'name',
                        hintText: 'Name *',
                        prefixIcon: Icons.person_2_outlined,
                        validationMessages: {
                          'required': (control) => 'The name is required',
                          'name': (control) => 'Please enter a valid name',
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
                        formControlName: 'email',
                        hintText: 'Email *',
                        prefixIcon: Icons.email_outlined,
                        validationMessages: {
                          'required': (control) => 'The email is required',
                          'email': (control) => 'Please enter a valid email',
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
                        formControlName: 'password',
                        hintText: 'Password *',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validationMessages: {
                          'required': (control) => 'The password is required',
                          'minLength': (control) =>
                              'Password must be at least 8 characters',
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
                        formControlName: 'confirmPassword',
                        hintText: 'Confirm Password *',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validationMessages: {
                          'required': (control) => 'The password is required',
                          'minLength': (control) =>
                              'Password must be at least 8 characters',
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
                        formControlName: 'mobile',
                        hintText: 'Mobile',
                        prefixIcon: Icons.mobile_friendly,
                        validationMessages: {
                          'required': (control) => 'The mobile is required',
                          'mobile': (control) => 'Please enter a valid mobile',
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveDropdown<String>(
                        formControlName: 'role',
                        hintText: 'Select Designation',
                        prefixIcon: Icons.design_services_outlined,
                        items: const [
                          DropdownMenuItem(
                            value: 'I am pursing PhD',
                            child: Text('I am pursing PhD'),
                          ),
                          DropdownMenuItem(
                            value: 'I have completed PhD',
                            child: Text('I have completed PhD'),
                          ),
                          DropdownMenuItem(
                            value: 'I am PhD Consultant',
                            child: Text('I am PhD Consultant'),
                          ),
                        ],
                        validationMessages: {
                          'required': (control) => 'Please select a role',
                        },
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            form.markAllAsTouched();
                          },
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('You already have an account? Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
