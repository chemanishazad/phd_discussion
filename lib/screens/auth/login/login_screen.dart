import 'package:flutter/material.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:provider/provider.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FormGroup form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
  });

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                        height: 35.h,
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
                      top: 20.h,
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
                        'Login',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
                        formControlName: 'email',
                        hintText: 'Email',
                        prefixIcon: Icons.person,
                        validationMessages: {
                          'required': (control) => 'The email is required',
                          'email': (control) => 'Please enter a valid email',
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomReactiveTextField(
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
                              'Password must be at least 8 characters',
                        },
                      ),
                      SizedBox(height: 1.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password'),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (form.valid) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    final email = form.control('email').value;
                                    final password =
                                        form.control('password').value;

                                    try {
                                      final message = await authProvider.login(
                                          email, password);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(message),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('An error occurred: $e'),
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    form.markAllAsTouched();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please fill in all fields'),
                                      ),
                                    );
                                  }
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: const Text('New User ? Register here')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
