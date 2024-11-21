import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final FormGroup form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)]),
  });

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String title =
        args != null && args.containsKey('title') ? args['title'] : '';
    print('title$title');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.lightBackgroundColor,
        body: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Image.asset(
                  'assets/icons/logo2.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 7.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ==
                                'Login to ask more relevant questions or answer questions on PhD discussions.'
                            ? 'Login to ask more relevant questions or answer questions on PhD discussions.'
                            : 'Login',
                        style: TextStyle(
                          fontSize: 20.sp,
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: const Text('Forgot Password'),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 150,
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
                                        final message = await authNotifier
                                            .login(email, password);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(message),
                                          ),
                                        );
                                        print('message$message');
                                        if (message.toLowerCase() ==
                                            'login successful.') {
                                          title == 'withoutLogin'
                                              ? Navigator.pushReplacementNamed(
                                                  context, '/home')
                                              : Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        print(e);
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Please fill in all fields'),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.themeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      )
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
