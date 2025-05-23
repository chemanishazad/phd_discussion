import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/provider/NavProvider/career/careerProvider.dart';

class WebinarApplyScreen extends ConsumerStatefulWidget {
  const WebinarApplyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WebinarApplyScreenState();
}

class _WebinarApplyScreenState extends ConsumerState<WebinarApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  String id = '';

  String? selectedCountry;
  String? selectedState;
  String? selectedArea;
  String? selectedStage;
  String fullName = '';
  String email = '';
  String phoneNumber = '';
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    final arg = ModalRoute.of(context)!.settings.arguments as String;
    print('arg$arg');
    setState(() {
      id = arg;
    });

    super.didChangeDependencies();
  }

  final List<String> researchAreas = [
    'Management',
    'Human Resource',
    'Finance',
    'Mechanical engineering',
    'Electrical Engineering',
    'Literature',
    'Chemistry',
    'IT',
    'Medical',
    'Others',
  ];

  final List<String> researchStages = [
    'Just Registered in PhD Programme',
    'Already started research',
    'Conducting research',
  ];

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
    'West Bengal'
  ];

  @override
  void dispose() {
    _universityController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.themeColor,
        title: const Text(
          'Webinar Application',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Personal Information', style: theme.headlineMedium),
              // const SizedBox(height: 15),

              // Full Name Field
              TextFormField(
                decoration: inputDecoration(context).copyWith(
                  labelText: 'Full Name',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onChanged: (value) => fullName = value,
              ),
              const SizedBox(height: 6),

              // Email Field
              TextFormField(
                decoration: inputDecoration(context).copyWith(
                  labelText: 'Email',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) => email = value,
              ),
              const SizedBox(height: 6),

              // Phone Number Field
              TextFormField(
                decoration: inputDecoration(context).copyWith(
                    labelText: 'Phone Number',
                    labelStyle: theme.bodySmall,
                    prefixIcon: const Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onChanged: (value) => phoneNumber = value,
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                decoration: inputDecoration(context).copyWith(
                  labelText: 'Area of Research',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.science),
                ),
                items: researchAreas
                    .map((area) => DropdownMenuItem(
                          value: area,
                          child: Text(area),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select area of research' : null,
                style: theme.bodySmall,
              ),
              const SizedBox(height: 6),

// Current Stage of Research Dropdown
              DropdownButtonFormField<String>(
                decoration: inputDecoration(context).copyWith(
                  labelText: 'Current Stage of Research',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.timeline),
                ),
                items: researchStages
                    .map((stage) => DropdownMenuItem(
                          value: stage,
                          child: Text(stage),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStage = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your current stage' : null,
                style: theme.bodySmall,
              ),
              const SizedBox(height: 6),

              // Address Field
              TextFormField(
                controller: _universityController,
                decoration: inputDecoration(context).copyWith(
                  labelText: 'University Name',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.school),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your University';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressController,
                decoration: inputDecoration(context).copyWith(
                  labelText: 'Full Address',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.home),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),

              // City Field
              TextFormField(
                controller: _cityController,
                decoration: inputDecoration(context).copyWith(
                  labelText: 'City',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                decoration: inputDecoration(context).copyWith(
                  labelText: 'State',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.map),
                ),
                value: selectedState,
                items: indianStates
                    .map((state) => DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your state' : null,
              ),
              const SizedBox(height: 6),

              // Pincode Field
              TextFormField(
                controller: _pincodeController,
                decoration: inputDecoration(context).copyWith(
                  labelText: 'Postal/Zip Code',
                  labelStyle: theme.bodySmall,
                  prefixIcon: const Icon(Icons.markunread_mailbox),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // Submit Button
              Center(
                child: CustomButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      final response = await ref.read(webinarRegister({
                        'webinar_id': id,
                        'full_name': fullName,
                        'email': email,
                        'phone': phoneNumber,
                        'area_of_research': selectedArea,
                        'current_stage': selectedStage,
                        'university_name': _universityController.text,
                        'full_address': _addressController.text,
                        'city': _cityController.text,
                        'state': selectedState,
                        'pincode': _pincodeController.text,
                      }).future);
                      print(response);
                      if (response['status'] == true) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: response['message']);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        Fluttertoast.showToast(msg: response['message']);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Submit Application',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for input decoration
  InputDecoration inputDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Palette.themeColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      filled: true,
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
      prefixIconColor: isDark ? Colors.white70 : Colors.black54,
    );
  }
}
