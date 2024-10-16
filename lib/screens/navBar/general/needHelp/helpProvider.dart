import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';

class HelpSubmissionState {
  final String? message;
  final bool isLoading;
  final bool hasError;

  HelpSubmissionState({
    this.message,
    this.isLoading = false,
    this.hasError = false,
  });
}

class HelpSubmissionNotifier extends StateNotifier<HelpSubmissionState> {
  HelpSubmissionNotifier() : super(HelpSubmissionState());

  Future<void> submitHelpRequest(String issueType, String comments) async {
    state = HelpSubmissionState(isLoading: true);
    try {
      final response = await submitHelp(issueType, comments);
      // Check for the success status and set the message accordingly
      state = HelpSubmissionState(
        message: response['message'], // Assuming response is a Map
        isLoading: false,
      );
    } catch (e) {
      state = HelpSubmissionState(
        hasError: true,
        message: 'Please try again.',
        isLoading: false,
      );
    }
  }
}


final helpSubmissionProvider =
    StateNotifierProvider<HelpSubmissionNotifier, HelpSubmissionState>((ref) {
  return HelpSubmissionNotifier();
});
