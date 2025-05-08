import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<dynamic> locationType;
  final List<dynamic> categoryType;
  final FormGroup form;
  final VoidCallback onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.categoryType,
    required this.locationType,
    required this.form,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _minSalary = 2;
  double _maxSalary = 10;

  final List<Map<String, String>> experienceOptions = [
    {'label': '0-1 years', 'value': '0-1'},
    {'label': '1-3 years', 'value': '1-3'},
    {'label': '3-5 years', 'value': '3-5'},
    {'label': '5-10 years', 'value': '5-10'},
    {'label': '10+ years', 'value': '10+'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ReactiveForm(
      formGroup: widget.form,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text('Filter Jobs', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              ReactiveDropdownField<String>(
                formControlName: 'category',
                decoration:
                    DropdownTheme.inputDecoration(context, label: 'Category'),
                style: Theme.of(context).brightness == Brightness.dark
                    ? const TextStyle(color: Colors.black) // for dark theme fix
                    : null,
                dropdownColor:
                    Colors.white, // ensures dropdown list has white background
                items: widget.categoryType
                    .map<DropdownMenuItem<String>>((location) {
                  return DropdownMenuItem<String>(
                    value: location['id'],
                    child: Text(
                      location['category_name'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black), // ensures readable items
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              ReactiveDropdownField<String>(
                formControlName: 'location',
                decoration:
                    DropdownTheme.inputDecoration(context, label: 'Location'),
                style: Theme.of(context).brightness == Brightness.dark
                    ? const TextStyle(color: Colors.black)
                    : null,
                dropdownColor: Colors.white,
                items: widget.locationType
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

              const SizedBox(height: 16),

              ReactiveDropdownField<String>(
                formControlName: 'experience',
                decoration:
                    DropdownTheme.inputDecoration(context, label: 'Experience'),
                dropdownColor: Colors.white,
                style: Theme.of(context).brightness == Brightness.dark
                    ? const TextStyle(color: Colors.black)
                    : null,
                items: experienceOptions.map((exp) {
                  return DropdownMenuItem<String>(
                    value: exp['value'],
                    child: Text(exp['label']!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Salary Range Filter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Salary Range (LPA)',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: RangeSlider(
                      values: RangeValues(_minSalary, _maxSalary),
                      min: 2,
                      max: 10,
                      divisions: 16,
                      labels: RangeLabels(
                        '₹${_minSalary.toStringAsFixed(1)} L',
                        '₹${_maxSalary.toStringAsFixed(1)} L',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minSalary = (values.start * 2).round() / 2.0;
                          _maxSalary = (values.end * 2).round() / 2.0;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Apply Filters Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  widget.form.control('min_salary').value =
                      _minSalary.toString();
                  widget.form.control('max_salary').value =
                      _maxSalary.toString();

                  widget.onApplyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
