import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: theme.iconTheme.color)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 15.0,
        ),
      ),
      dropdownColor: theme.cardColor,
      hint: Center(
        child: Text(
          hintText,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.black,
      ),
      items: items,
    );
  }
}
