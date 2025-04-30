import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_filed2.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ShowInterestScreen extends ConsumerStatefulWidget {
  const ShowInterestScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowInterestScreenState();
}

class _ShowInterestScreenState extends ConsumerState<ShowInterestScreen> {
  final FormGroup form = FormGroup({
    'firstName': FormControl<String>(
      validators: [Validators.required, Validators.minLength(2)],
    ),
    'lastName': FormControl<String>(
      validators: [Validators.required, Validators.minLength(2)],
    ),
    'emailId': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'mobileNo': FormControl<String>(
      validators: [Validators.required, Validators.pattern(r'^[0-9]{10}$')],
    ),
    'interest': FormControl<String>(),
  });

  @override
  Widget build(BuildContext context) {
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
                formControlName: 'firstName',
                label: 'First Name',
                hint: 'Enter your First Name',
                icon: Icons.person,
              ),
              CustomReactiveTextField2(
                formControlName: 'lastName',
                label: 'Last Name',
                hint: 'Enter your Last Name',
                icon: Icons.person_outline,
              ),
              CustomReactiveTextField2(
                formControlName: 'emailId',
                label: 'Email',
                hint: 'Enter your Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomReactiveTextField2(
                formControlName: 'mobileNo',
                label: 'Mobile No',
                hint: 'Enter Mobile No',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              CustomReactiveTextField2(
                formControlName: 'interest',
                label: 'Interest',
                hint: 'Enter your area of interest',
                icon: Icons.interests,
                maxLine: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
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
                            msg: "Please fill all required fields correctly!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
