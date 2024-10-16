import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final Function(String)? onSelectionChanged;
  final IconData icon;
  final String? title;
  final Color? iconColor;
  final String? initialValue;
  final double dropdownWidth; // Width of the dropdown box
  final double dropdownHeight; // Height of the dropdown box

  const CustomDropDown({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.icon = Icons.arrow_drop_down,
    this.title,
    this.initialValue,
    this.iconColor,
    this.dropdownWidth = 120, // Default dropdown box width
    this.dropdownHeight = 40, // Default dropdown box height
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropdownWidth,
      height: widget.dropdownHeight, // Set the height of the dropdown box
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 0), // Reduced vertical padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.iconColor ?? Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                  widget.title ?? 'Please select',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                value: _selectedItem,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 20,
                elevation: 4,
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
                      style: const TextStyle(fontSize: 14),
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
