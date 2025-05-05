import 'dart:convert'; // Add this for json.decode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/components/reactive_dropdown.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Your tagProvider to fetch the tags
final tagProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await getTag();
  if (response['status'] == true) {
    return List<Map<String, dynamic>>.from(response['tags']);
  } else {
    throw Exception('Failed to fetch tags');
  }
});

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final Map<String, String> _selectedTags =
      {}; // To store selected tag ids and brands
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
    final authNotifier = ref.read(authProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 7.h),
                _buildHeader(),
                SizedBox(height: 4.h),
                _buildForm(authNotifier),
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

  Widget _buildHeader() {
    return Image.asset(
      'assets/icons/logo2.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildForm(authNotifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 20.sp,
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
            },
          ),
          SizedBox(height: 2.h),
          // CustomReactiveTextField(
          //   formControlName: 'email',
          //   hintText: 'Email *',
          //   prefixIcon: Icons.email_outlined,
          //   validationMessages: {
          //     'required': (control) => 'The email is required',
          //     'email': (control) => 'Please enter a valid email',
          //   },
          // ),
          // SizedBox(height: 2.h),

          CustomReactiveTextField(
            formControlName: 'mobile',
            hintText: 'Mobile',
            prefixIcon: Icons.mobile_friendly,
            validationMessages: {
              'mobile': (control) => 'Please enter a valid mobile number',
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
              'required': (control) => 'The confirm password is required',
              'minLength': (control) =>
                  'Confirm password must be at least 8 characters',
            },
          ),

          SizedBox(height: 2.h),
          // CustomDropdown<String>(
          //   hintText: 'Select Designation',

          //   prefixIcon: Icons.design_services_outlined,
          //   value: null, // No value selected initially
          //   items: [
          //     DropdownMenuItem(
          //       value: '1',
          //       child: Text('I am pursuing PhD',
          //           style: Theme.of(context).textTheme.bodyMedium),
          //     ),
          //     DropdownMenuItem(
          //       value: '2',
          //       child: Text('I have completed PhD',
          //           style: Theme.of(context).textTheme.bodyMedium),
          //     ),
          //     DropdownMenuItem(
          //       value: '3',
          //       child: Text('I am PhD Consultant',
          //           style: Theme.of(context).textTheme.bodyMedium),
          //     ),
          //   ],
          //   onChanged: (value) {
          //     print('Selected value: $value');
          //     setState(() {
          //       form.control('role').value = value;
          //     });
          //     print('Selected value2: ${form.control('role').value}');
          //   },
          // ),
          // SizedBox(height: 2.h),
          // _buildTagDropdown(),
          SizedBox(height: 2.h),
          Center(
            child: CustomButton(
              onTap: () async {
                form.markAllAsTouched();
                final selectedTagIds = _selectedTags.keys.toList();
                final formValue = form.value;
                print("Form Value: $formValue");
                print("Selected Tag IDs: $selectedTagIds");

                if (form.valid) {
                  try {
                    setState(() => isLoading = true);

                    // Call signUp with form data and selected tag IDs
                    final message = await authNotifier.signUp(
                      form.control('name').value,
                      form.control('email').value,
                      form.control('password').value,
                      form.control('confirmPassword').value,
                      form.control('mobile').value ?? '',
                      form.control('role').value,
                      selectedTagIds,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );

                    if (message.toLowerCase() == 'signup successful.') {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                }
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showTagSelectionDialog(),
          child: InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.label),
              border: OutlineInputBorder(),
            ),
            child: Wrap(
              spacing: 8.0,
              children: _selectedTags.isEmpty
                  ? [const Text('Select Tags')]
                  : _selectedTags.entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        onDeleted: () {
                          setState(() {
                            _selectedTags.remove(entry.key);
                          });
                        },
                      );
                    }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showTagSelectionDialog() async {
    final tagsAsyncValue = await ref.read(tagProvider.future);

    if (tagsAsyncValue.isEmpty) {
      return;
    }

    final Map<String, bool> tagSelectionState = {};
    for (var tag in tagsAsyncValue) {
      tagSelectionState[tag['id']] = _selectedTags.containsKey(tag['id']);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Tags',
                  style: Theme.of(context).textTheme.headlineMedium),
              content: SingleChildScrollView(
                child: ListBody(
                  children: tagsAsyncValue.map((tag) {
                    return CheckboxListTile(
                      title: Text(
                          tag['brand'].isEmpty ? 'Select Tags' : tag['brand']),
                      value: tagSelectionState[tag['id']],
                      onChanged: (isChecked) {
                        setState(() {
                          final selectedCount = _selectedTags.length;

                          if (isChecked == true && selectedCount >= 5) {
                            // Show a message when max selection is reached
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('You can only select up to 5 tags.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          tagSelectionState[tag['id']] = isChecked ?? false;
                          if (isChecked == true) {
                            _selectedTags[tag['id']] =
                                tag['brand']; // Store the id and brand
                          } else {
                            _selectedTags.remove(tag['id']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }
}
