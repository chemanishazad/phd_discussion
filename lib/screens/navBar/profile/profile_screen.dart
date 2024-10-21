import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController designationController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile['status'] == true) {
            final userData = profile['data'];

            if (!_isEditing) {
              nameController = TextEditingController(text: userData['name']);
              emailController = TextEditingController(text: userData['email']);
              mobileController =
                  TextEditingController(text: userData['mobile']);
              designationController =
                  TextEditingController(text: userData['designation']);
              descriptionController =
                  TextEditingController(text: userData['description']);
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileField(
                        'Name:', nameController, userData['name']),
                    _buildProfileField(
                        'Email:', emailController, userData['email']),
                    _buildProfileField(
                        'Mobile:', mobileController, userData['mobile']),
                    _buildProfileField('Designation:', designationController,
                        userData['designation']),
                    _buildProfileField('About Me:', descriptionController,
                        userData['description'],
                        maxLines: 3),
                    const SizedBox(height: 20),
                    _buildProfilePercentageBar(profile['profile_percentage']),
                    const SizedBox(height: 20),
                    _buildInterestSection(),
                    const SizedBox(height: 20),
                    _buildCategoriesSection(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isEditing
                          ? () => _saveProfile()
                          : () => setState(() => _isEditing = true),
                      child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Failed to load profile data.'));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProfileField(
      String label, TextEditingController controller, String value,
      {int maxLines = 1}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            _isEditing
                ? TextFormField(controller: controller, maxLines: maxLines)
                : Text(value),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePercentageBar(dynamic percentage) {
    int safePercentage = (percentage is int) ? percentage : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile Completion: $safePercentage%',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: safePercentage / 100),
      ],
    );
  }

  Widget _buildInterestSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Interests:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
                'Interest 1, Interest 2, Interest 3'), // Replace with dynamic data
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logic to add interest
              },
              child: const Text('Add Interest'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Categories:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Category 1, Category 2'), // Replace with dynamic data
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logic to add category
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    // Collect the updated data
    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'designation': designationController.text,
      'description': descriptionController.text,
    };

    // Print the updated data
    print("Updated Profile Data: $updatedData");

    setState(() {
      _isEditing = false; // Disable editing mode after saving
    });

    // Here you would add your API call to save the updated data
  }
}
