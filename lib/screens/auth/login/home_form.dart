import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:reactive_forms/reactive_forms.dart';

class HomeForm extends ConsumerStatefulWidget {
  const HomeForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFormState();
}

class _HomeFormState extends ConsumerState<HomeForm> {
  final FormGroup form = FormGroup({
    'expertise': FormControl<String>(validators: [Validators.required]),
    'status': FormControl<String>(validators: [Validators.required]),
    'applyingForPhD': FormControl<bool>(value: false),
    'notPlanningForPhD': FormControl<bool>(value: false),
    'yearOfRegistration': FormControl<String>(),
    'phdDomain': FormControl<String>(),
    'phdComplete': FormControl<String>(),
    'postDoctoral': FormControl<String>(),
    'state': FormControl<String>(validators: [Validators.required]),
  });

  final List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  final List<String> statusOptions = [
    'Not yet registered in PhD',
    'Pursuing PhD',
    'PhD Completed',
    'Post Doctoral'
  ];

  final List<String> phdDomains = [
    'Computer Science',
    'Engineering',
    'Physics',
    'Mathematics',
    'Biology',
    'Chemistry',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Palette.themeColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Verification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Area of Expertise', style: theme.headlineLarge),
                const SizedBox(height: 10),
                ReactiveTextField<String>(
                  formControlName: 'expertise',
                  decoration: InputDecoration(
                    labelText: 'Enter your expertise',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (error) =>
                        'Expertise is required',
                    ValidationMessage.email: (error) =>
                        'Please enter a valid email',
                  },
                ),
                const SizedBox(height: 8),
                Text('Status', style: theme.headlineLarge),
                const SizedBox(height: 8),
                ReactiveDropdownField<String>(
                  formControlName: 'status',
                  decoration: InputDecoration(
                    hintText: 'Select your status',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  items: statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status,
                                style: theme.bodyLarge
                                    ?.copyWith(color: Colors.black)),
                          ))
                      .toList(),
                  dropdownColor: Colors.white,
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Status is required',
                  },
                ),
                // Dynamic checkboxes for status "Not yet registered in PhD"
                ReactiveValueListenableBuilder<String>(
                  formControlName: 'status',
                  builder: (context, control, child) {
                    if (control.value == 'Not yet registered in PhD') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text('Future Plans', style: theme.headlineLarge),
                          const SizedBox(height: 10),
                          // Custom Checkbox for 'Applying for PhD'
                          CustomCheckbox(
                            form: form, // Pass the form here
                            formControlName: 'applyingForPhD',
                            title: 'Applying for PhD',
                          ),
                          // Custom Checkbox for 'Not Planning for PhD'
                          CustomCheckbox(
                            form: form, // Pass the form here
                            formControlName: 'notPlanningForPhD',
                            title: 'Not Planning for PhD',
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Dynamic form elements for "Pursuing PhD" status
                ReactiveValueListenableBuilder<String>(
                  formControlName: 'status',
                  builder: (context, control, child) {
                    if (control.value == 'Pursuing PhD') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Year of Registration',
                              style: theme.headlineLarge),
                          const SizedBox(height: 8),
                          ReactiveDropdownField<String>(
                            formControlName: 'yearOfRegistration',
                            decoration: InputDecoration(
                              hintText: 'Select year of registration',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                            items: List.generate(16, (index) {
                              int year = DateTime.now().year - index;
                              return DropdownMenuItem(
                                value: year.toString(),
                                child: Text(year.toString(),
                                    style: theme.bodyLarge
                                        ?.copyWith(color: Colors.black)),
                              );
                            }),
                            dropdownColor: Colors.white,
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Year of registration is required',
                            },
                          ),
                          const SizedBox(height: 8),
                          Text('Domain of PhD', style: theme.headlineLarge),
                          const SizedBox(height: 8),
                          ReactiveDropdownField<String>(
                            formControlName: 'phdDomain',
                            decoration: InputDecoration(
                              hintText: 'Select your PhD domain',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                            items: phdDomains
                                .map((domain) => DropdownMenuItem(
                                      value: domain,
                                      child: Text(domain,
                                          style: theme.bodyLarge
                                              ?.copyWith(color: Colors.black)),
                                    ))
                                .toList(),
                            dropdownColor: Colors.white,
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'PhD domain is required',
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ReactiveValueListenableBuilder<String>(
                  formControlName: 'status',
                  builder: (context, control, child) {
                    if (control.value == 'PhD Completed') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Year of Complete', style: theme.headlineLarge),
                          const SizedBox(height: 8),
                          ReactiveDropdownField<String>(
                            formControlName: 'phdComplete',
                            decoration: InputDecoration(
                              hintText: 'Select year of completion',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                            items: List.generate(30, (index) {
                              int year = DateTime.now().year - index;
                              return DropdownMenuItem(
                                value: year.toString(),
                                child: Text(year.toString(),
                                    style: theme.bodyLarge
                                        ?.copyWith(color: Colors.black)),
                              );
                            }),
                            dropdownColor: Colors.white,
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Year of registration is required',
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ReactiveValueListenableBuilder<String>(
                  formControlName: 'status',
                  builder: (context, control, child) {
                    if (control.value == 'Post Doctoral') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Domain of Research',
                              style: theme.headlineLarge),
                          const SizedBox(height: 8),
                          ReactiveDropdownField<String>(
                            formControlName: 'postDoctoral',
                            decoration: InputDecoration(
                              hintText: 'Select your PhD Doctoral',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                            items: phdDomains
                                .map((domain) => DropdownMenuItem(
                                      value: domain,
                                      child: Text(domain,
                                          style: theme.bodyLarge
                                              ?.copyWith(color: Colors.black)),
                                    ))
                                .toList(),
                            dropdownColor: Colors.white,
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'PhD domain is required',
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 8),
                Text('City', style: theme.headlineLarge),
                const SizedBox(height: 8),
                ReactiveDropdownField<String>(
                  formControlName: 'state',
                  decoration: InputDecoration(
                    hintText: 'Select your state',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  items: indianStates
                      .map((state) => DropdownMenuItem(
                            value: state,
                            child: Text(state,
                                style: theme.bodyLarge
                                    ?.copyWith(color: Colors.black)),
                          ))
                      .toList(),
                  dropdownColor: Colors.white,
                  validationMessages: {
                    ValidationMessage.required: (error) =>
                        'State selection is required',
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                      // final expertise = form.control('expertise').value;
                      // final status = form.control('status').value;
                      // final applyingForPhD =
                      //     form.control('applyingForPhD').value;
                      // final notPlanningForPhD =
                      //     form.control('notPlanningForPhD').value;

                      // print('Expertise: $expertise');
                      // print('Status: $status');
                      // if (status == 'Not yet registered in PhD') {
                      //   print('Applying for PhD: $applyingForPhD');
                      //   print('Not Planning for PhD: $notPlanningForPhD');
                      // }
                    },
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.themeColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final FormGroup form; // Add this line
  final String formControlName;
  final String title;

  const CustomCheckbox({
    required this.form, // Add this line
    required this.formControlName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveCheckboxListTile(
      formControlName: formControlName,
      title: Text(title),
      activeColor: Palette.themeColor,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onChanged: (value) {
        // If "Applying for PhD" is checked, uncheck the "Not Planning for PhD"
        if (form.control('applyingForPhD').value == true &&
            formControlName == 'applyingForPhD') {
          form.control('notPlanningForPhD').value = false;
        } else if (form.control('notPlanningForPhD').value == true &&
            formControlName == 'notPlanningForPhD') {
          form.control('applyingForPhD').value = false;
        }
      },
    );
  }
}
