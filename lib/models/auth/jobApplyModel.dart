import 'dart:io';

class JobApplyModel {
  final List<File> file;
  final String jobId;
  final String name;
  final String mobile;
  final String currentLocation;
  final String prefLocation;
  final String highestQualification;
  final String workExperience;
  final String currentCtc;
  final String reasonForApply;

  JobApplyModel({
    required this.file,
    required this.jobId,
    required this.name,
    required this.mobile,
    required this.currentLocation,
    required this.prefLocation,
    required this.highestQualification,
    required this.workExperience,
    required this.currentCtc,
    required this.reasonForApply,
  });
}
