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
    final theme = Theme.of(context);

    return ReactiveTextField(
      formControlName: formControlName,
      obscureText: obscureText,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onBackground, // Adjust text color explicitly
      ),
      decoration: InputDecoration(
        hintText: hintText, // Hint text
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onBackground.withOpacity(0.6), // Hint color
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: theme.colorScheme.primary, // Icon color
              )
            : null,
        suffixIcon: onSuffixIconPressed != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () => onSuffixIconPressed!(),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant, // Background color
      ),
      validationMessages: validationMessages,
    );
  }
}
