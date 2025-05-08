import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_filed2.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/models/auth/jobApplyModel.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';
import 'package:phd_discussion/screens/navBar/merchandise/merchandiseHome/dummyData.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:open_file/open_file.dart';

class JobApplyForm extends ConsumerStatefulWidget {
  const JobApplyForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JobApplyFormState();
}

class _JobApplyFormState extends ConsumerState<JobApplyForm> {
  final FormGroup form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'mobile': FormControl<String>(validators: [Validators.required]),
    'highQualification': FormControl<String>(validators: [Validators.required]),
    'workExp': FormControl<String>(validators: [Validators.required]),
    'location': FormControl<String>(validators: [Validators.required]),
    'currentLocation': FormControl<String>(validators: [Validators.required]),
    'expSalary': FormControl<String>(),
    'current_ctc': FormControl<String>(),
    'reasonForApply': FormControl<String>(),
  });

  String jobId = '';
  List<File> selectedResume = [];
  int _selectedTabIndex = 0;
  List<dynamic> locationData = [];
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    final arg =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      jobId = arg['id'];
    });
    initData();
    super.didChangeDependencies();
  }

  Future<void> initData() async {
    final loc = await ref.read(locationProvider.future);

    setState(() {
      locationData = loc['categories'];
    });

    print('locationData>>$locationData');
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedResume = result.files.map((file) => File(file.path!)).toList();
      });
    } else {
      Fluttertoast.showToast(msg: "No file selected");
    }
  }

  void _removeResume(File file) {
    setState(() {
      selectedResume.remove(file);
    });
  }

  void _openResume(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not open resume: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.themeColor,
        title: const Text(
          'Job Application',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: _selectedTabIndex == 0
                            ? Palette.themeColor
                            : Colors.grey[300],
                        foregroundColor: _selectedTabIndex == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () => setState(() => _selectedTabIndex = 0),
                      child: const Text('Fresher'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: _selectedTabIndex == 1
                            ? Palette.themeColor
                            : Colors.grey[300],
                        foregroundColor: _selectedTabIndex == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () => setState(() => _selectedTabIndex = 1),
                      child: const Text('Experienced'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Common Fields
              CustomReactiveTextField2(
                formControlName: 'name',
                label: 'Full Name',
                hint: 'Enter your name',
                icon: Icons.person,
              ),
              CustomReactiveTextField2(
                formControlName: 'mobile',
                label: 'Mobile Number',
                hint: 'Enter your mobile number',
                icon: Icons.phone,
              ),
              CustomReactiveTextField2(
                formControlName: 'highQualification',
                label: 'Highest Qualification',
                hint: 'Enter your qualification',
                icon: Icons.school,
              ),
              if (_selectedTabIndex == 1) ...[
                CustomReactiveTextField2(
                  formControlName: 'workExp',
                  label: 'Work Experience (in years)',
                  hint: 'Enter your work experience',
                  icon: Icons.business_center,
                ),
                CustomReactiveTextField2(
                  formControlName: 'current_ctc',
                  label: 'Current CTC (₹)',
                  hint: 'Enter your current CTC',
                  icon: Icons.monetization_on,
                ),
              ],
              // Location Dropdown - Fixed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Location'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: ReactiveDropdownField<String>(
                      isDense: true,
                      formControlName: 'location',
                      hint: Text('Location'),
                      style: Theme.of(context).brightness == Brightness.dark
                          ? const TextStyle(color: Colors.black)
                          : null,
                      dropdownColor: Colors.white,
                      items: locationData
                          .map<DropdownMenuItem<String>>((location) {
                        return DropdownMenuItem<String>(
                          value: location['id'],
                          child: Text(location['location_name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Current Location Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Location'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: ReactiveDropdownField<String>(
                      formControlName: 'currentLocation',
                      hint: Text('Current Location'),
                      isDense: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      dropdownColor: Colors.white,
                      style: Theme.of(context).brightness == Brightness.dark
                          ? const TextStyle(color: Colors.black)
                          : null,
                      items: locationPrefer.map((exp) {
                        return DropdownMenuItem<String>(
                          value: exp['value'],
                          child: Text(
                            exp['name'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Tab Specific Fields

              CustomReactiveTextField2(
                formControlName: 'expSalary',
                label: 'Expected Salary',
                hint: 'Enter expected salary',
                icon: Icons.currency_rupee_rounded,
              ),
              CustomReactiveTextField2(
                formControlName: 'reasonForApply',
                label: 'Reason For Apply',
                hint: 'Enter Reason',
                icon: Icons.work,
              ),
              const SizedBox(height: 10),

              // Resume Upload Section
              _buildResumeSection(),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(form.value);
                      form.markAllAsTouched();

                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final res = await ref.read(jobApplyProvider(
                          JobApplyModel(
                              file: selectedResume,
                              jobId: jobId,
                              name: form.control('name').value,
                              mobile: form.control('mobile').value,
                              currentLocation:
                                  form.control('currentLocation').value,
                              prefLocation: form.control('location').value,
                              highestQualification:
                                  form.control('highQualification').value,
                              workExperience:
                                  form.control('workExp').value ?? '',
                              currentCtc:
                                  form.control('current_ctc').value ?? '',
                              reasonForApply:
                                  form.control('reasonForApply').value ?? ''),
                        ).future);
                        print('object>>>$res');
                        Fluttertoast.showToast(msg: res['message']);

                        if (res['status'] == true) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: res['message']);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          Fluttertoast.showToast(msg: res['message']);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          isLoading = false;
                        });
                      }
                      print('Form Values: ${form.value}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: const Text("Submit Application"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumeSection() {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resume Upload', style: theme.titleLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickResume,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.upload_file, color: Colors.white),
                SizedBox(width: 10),
                Text("Upload Resume", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...selectedResume.map((file) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: cardDecoration(context: context),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
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
                            file.path.split('/').last,
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
                      onPressed: () => _openResume(file),
                      icon: const Icon(Icons.visibility, color: Colors.green),
                    ),
                    IconButton(
                      onPressed: () => _removeResume(file),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
