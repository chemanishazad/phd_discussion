import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final Function(String)? onSelectionChanged;
  final IconData icon;
  final String? title;
  final Color? iconColor;
  final String? initialValue; // Add this line to accept the initial value

  const CustomDropDown({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.icon = Icons.arrow_drop_down,
    this.title,
    this.initialValue,
    this.iconColor, // Initialize the new property
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue; // Set the initial value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: const Color.fromARGB(255, 223, 223, 223),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            Icon(widget.icon,
                color: widget.iconColor ?? Colors.black,
                size: 24), // Custom icon
            SizedBox(width: 8), // Space between icon and dropdown button
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                  widget.title ?? 'please select',
                  style: TextStyle(fontSize: 16),
                ),
                value: _selectedItem,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 12),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                    if (widget.onSelectionChanged != null) {
                      widget.onSelectionChanged!(newValue);
                    }
                  }
                },
                items:
                    widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
