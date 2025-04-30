import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_filed2.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:open_file/open_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JobApplyForm extends ConsumerStatefulWidget {
  const JobApplyForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JobApplyFormState();
}

class _JobApplyFormState extends ConsumerState<JobApplyForm> {
  final FormGroup form = FormGroup({
    'highQualification': FormControl<String>(validators: [Validators.required]),
    'workExp': FormControl<String>(validators: [Validators.required]),
    'location': FormControl<String>(validators: [Validators.required]),
    'expSalary': FormControl<String>(validators: [Validators.required]),
    'joiningTime': FormControl<String>(),
  });

  File? selectedResume;

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedResume = File(result.files.first.path!);
      });
    }
  }

  void _removeResume() {
    setState(() {
      selectedResume = null;
    });
  }

  void _openResume() async {
    if (selectedResume != null) {
      try {
        OpenFile.open(selectedResume!.path);
      } catch (e) {
        Fluttertoast.showToast(msg: "Could not open resume: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView(
            children: [
              const SizedBox(height: 10),

              CustomReactiveTextField2(
                formControlName: 'highQualification',
                label: 'Highest Qualification',
                hint: 'Enter your qualification',
                icon: Icons.school,
              ),
              CustomReactiveTextField2(
                formControlName: 'workExp',
                label: 'Total Work Experience',
                hint: 'Enter your experience',
                icon: Icons.business_center,
              ),
              CustomReactiveTextField2(
                formControlName: 'location',
                label: 'Current Location',
                hint: 'Enter your location',
                icon: Icons.location_on,
              ),
              CustomReactiveTextField2(
                formControlName: 'expSalary',
                label: 'Expected Salary',
                hint: 'Enter expected salary',
                icon: Icons.currency_rupee_rounded,
              ),
              Text(
                'Days to take up new job',
                style: theme.headlineMedium,
              ),
              SizedBox(height: 1.h),
              ReactiveDropdownField<String>(
                formControlName: 'joiningTime',
                hint: Text(
                  'Select',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Palette.themeColor.withOpacity(0.1),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                items: [
                  'Available for Immediate Joining',
                  'One Week Notice Period',
                  '15 Days Notice Period',
                  '30 Days',
                  '45 Days',
                  '60 Days',
                  '75 Days',
                  '90 Days'
                ]
                    .map(
                      (label) => DropdownMenuItem(
                        value: label,
                        child: Container(
                          child: Text(label),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  print("Selected: $value");
                },
                dropdownColor: Colors.white,
              ),

              const SizedBox(height: 20),

              // Resume Upload Section
              _buildSection(
                title: "Resume Upload",
                children: [
                  if (selectedResume == null)
                    GestureDetector(
                      onTap: _pickResume,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 3,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF2196F3),
                              Color(0xFF1976D2)
                            ], // Blue gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.upload_file, color: Colors.white),
                            const SizedBox(width: 10),
                            Text("Upload Resume",
                                style: theme.titleLarge
                                    ?.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file,
                                size: 30, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Resume Selected",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    selectedResume!.path.split('/').last,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _openResume,
                              icon: const Icon(Icons.visibility,
                                  color: Colors.green),
                            ),
                            IconButton(
                              onPressed: _removeResume,
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Submit Button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 3,
                  child: ElevatedButton(
                    onPressed: () {
                      form.markAllAsTouched();
                      if (form.valid) {
                        Fluttertoast.showToast(msg: "Application Submitted!");
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please fill all required fields!");
                      }
                    },
                    child: const Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
