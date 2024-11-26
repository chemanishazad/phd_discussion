import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveTextField extends StatelessWidget {
  final String formControlName;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Function? onSuffixIconPressed;
  final Map<String, ValidationMessageFunction>? validationMessages;

  const CustomReactiveTextField({
    super.key,
    required this.formControlName,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.validationMessages,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControlName: formControlName,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: onSuffixIconPressed != null
            ? IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () => onSuffixIconPressed!(),
              )
            : SizedBox(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validationMessages: validationMessages,
    );
  }
}
