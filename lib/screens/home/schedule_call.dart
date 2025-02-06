import 'package:flutter/material.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';

class ScheduleCall extends StatefulWidget {
  const ScheduleCall({super.key});

  @override
  _ScheduleCallState createState() => _ScheduleCallState();
}

class _ScheduleCallState extends State<ScheduleCall> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitForm() {
    String title = _titleController.text;
    String phoneNumber = _phoneNumberController.text;
    String date = _selectedDate != null
        ? _selectedDate!.toLocal().toString().split(' ')[0]
        : 'Not selected';
    String time =
        _selectedTime != null ? _selectedTime!.format(context) : 'Not selected';

    print('Title: $title');
    print('Date: $date');
    print('Time: $time');
    print('Phone Number: $phoneNumber');

    // After submitting, show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Call Scheduled Successfully!')),
    );

    // Optionally, navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Palette.themeColor,
        title: const Text(
          'Schedule Call',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter details below to schedule your call.',
              style: theme.headlineMedium,
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Call Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                        : 'Select a Date',
                  ),
                ),
                CustomButton(
                  onTap: _pickDate,
                  child: const Text(
                    'Pick Date',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? 'Time: ${_selectedTime!.format(context)}'
                        : 'Select a Time',
                  ),
                ),
                CustomButton(
                  onTap: _pickTime,
                  child: const Text(
                    'Pick Time',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              onTap: _submitForm,
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
