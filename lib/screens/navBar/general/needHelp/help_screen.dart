import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/components/custom_dropdown.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

import 'helpProvider.dart';

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String? issue;
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final helpSubmissionState = ref.watch(helpSubmissionProvider);
    print(helpSubmissionState.message);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Need Help'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title('Issue Type'),
              CustomDropDown(
                items: const ['Technical Issue', 'General Issue'],
                dropdownWidth: MediaQuery.sizeOf(context).width / 1.5,
                onSelectionChanged: (value) {
                  setState(() {
                    issue = value;
                  });
                  print(issue);
                },
              ),
              const SizedBox(height: 8),
              _title('Comments'),
              TextField(
                controller: _commentsController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe your issue here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: CustomButton(
                  onTap: () async {
                    String comments = _commentsController.text;
                    print('Issue: $issue');
                    print('Comments: $comments');

                    if (issue != null && comments.isNotEmpty) {
                      await ref
                          .read(helpSubmissionProvider.notifier)
                          .submitHelpRequest(issue!, comments);

                      final helpSubmissionState =
                          ref.read(helpSubmissionProvider);

                      if (helpSubmissionState.message != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(helpSubmissionState.message!)),
                        );

                        Navigator.of(context).pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields.')),
                      );
                    }
                  },
                  child: helpSubmissionState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              // if (helpSubmissionState.message != null)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 16.0),
              //     child: Text(
              //       helpSubmissionState.message!,
              //       style: TextStyle(
              //         color: helpSubmissionState.hasError
              //             ? Colors.red
              //             : Colors.green,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
