import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveDropdown<T> extends StatelessWidget {
  final String formControlName;
  final String hintText;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final Map<String, ValidationMessageFunction>? validationMessages;

  const CustomReactiveDropdown({
    super.key,
    required this.formControlName,
    required this.hintText,
    required this.items,
    this.validationMessages,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<T>(
      formControlName: formControlName,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: items,
      validationMessages: validationMessages,
    );
  }
}
