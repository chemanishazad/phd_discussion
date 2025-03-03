import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<Map<String, String>> locationType;
  final FormGroup form;
  final VoidCallback onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.locationType,
    required this.form,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _minSalary = 3; // Minimum Salary in LPA
  double _maxSalary = 50; // Maximum Salary in LPA

  List<String> experienceOptions = [
    '0-1 years',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    '10+ years'
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

              // Location Filter
              ReactiveDropdownField<String>(
                formControlName: 'location',
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                items: widget.locationType.map((location) {
                  return DropdownMenuItem(
                    value: location['name'],
                    child: Text(location['name']!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Experience Filter
              ReactiveDropdownField<String>(
                formControlName: 'experience',
                decoration: const InputDecoration(
                  labelText: 'Experience',
                  border: OutlineInputBorder(),
                ),
                items: experienceOptions.map((exp) {
                  return DropdownMenuItem(
                    value: exp,
                    child: Text(exp),
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
                      min: 3,
                      max: 50,
                      divisions: 47,
                      labels: RangeLabels(
                        '₹${_minSalary.toStringAsFixed(0)} L',
                        '₹${_maxSalary.toStringAsFixed(0)} L',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minSalary = values.start;
                          _maxSalary = values.end;
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
                  widget.form.control('salary').value =
                      '${_minSalary.toStringAsFixed(0)}-${_maxSalary.toStringAsFixed(0)} LPA';
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
