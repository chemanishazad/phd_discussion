import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});
final tagProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await getTag();
  if (response['status'] == true) {
    return List<Map<String, dynamic>>.from(response['tags']);
  } else {
    throw Exception('Failed to fetch tags');
  }
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
  late TextEditingController researchDetailsController;
  late TextEditingController descriptionController;

  List<Map<String, dynamic>> _selectedTags = []; // Store selected tags

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    researchDetailsController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);
    final tagAsyncValue = ref.watch(tagProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile['status'] == true) {
            final userData = profile['data'];
            if (!_isEditing) {
              nameController.text = userData['name'];
              emailController.text = userData['email'];
              mobileController.text = userData['mobile'];
              descriptionController.text = userData['description'];
              _selectedTags = List<Map<String, dynamic>>.from(
                  userData['tags']); // Load initial selected tags
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(profileProvider);
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileCompletionBar(profile['profile_percentage']),
                      const SizedBox(height: 20),
                      _buildPersonalInformationSection(),
                      const SizedBox(height: 20),
                      _buildInterestsSection(),
                      const SizedBox(height: 20),
                      _buildCategoriesSection(userData['categories']),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Failed to load profile data.'));
          }
        },
        loading: () => _buildLoadingIndicator(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProfileCompletionBar(dynamic percentage) {
    int safePercentage = (percentage is int) ? percentage : 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Completion: $safePercentage%',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: safePercentage / 100,
              backgroundColor: Colors.grey[200],
              color: safePercentage >= 75
                  ? Colors.green
                  : safePercentage >= 50
                      ? Colors.orange
                      : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInformationSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Personal Information',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileField('Name', nameController),
            const SizedBox(height: 10),
            _buildProfileField('Email', emailController),
            const SizedBox(height: 10),
            _buildProfileField('Mobile', mobileController),
            !_isEditing
                ? const SizedBox()
                : _buildProfileField(
                    'Research Detail', researchDetailsController),
            const SizedBox(height: 10),
            _buildProfileField('About Me', descriptionController, maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _isEditing
            ? TextFormField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter your $label',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Text(controller.text,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 16)),
              ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Interests:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _selectedTags
                  .map((tag) => Chip(
                        label: Text(tag['brand']),
                        backgroundColor: Colors.blue[100],
                      ))
                  .toList(),
            ),
            if (_isEditing)
              ElevatedButton(
                onPressed: () => _showTagSelectionDialog(),
                child: const Text('Select Tags'),
              ),
          ],
        ),
      ),
    );
  }

  void _showTagSelectionDialog() async {
    final tags = await ref.read(tagProvider.future); // Get all tags
    List<Map<String, dynamic>> availableTags =
        List<Map<String, dynamic>>.from(tags);
    List<Map<String, dynamic>> selectedTagsCopy = List.from(_selectedTags);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Interests'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: availableTags.map((tag) {
                return CheckboxListTile(
                  title: Text(tag['brand']),
                  value: selectedTagsCopy.contains(tag),
                  onChanged: (isSelected) {
                    setState(() {
                      if (isSelected == true) {
                        selectedTagsCopy.add(tag);
                      } else {
                        selectedTagsCopy.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTags = selectedTagsCopy; // Update selected tags
                });
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesSection(List<dynamic> categories) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Categories:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: categories
                  .map((category) => Chip(
                        label: Text(category['category']),
                        backgroundColor: Colors.green[100],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_isEditing)
          ElevatedButton(
            onPressed: () {
              // Handle save logic
            },
            child: const Text('Save'),
          ),
      ],
    );
  }
}
