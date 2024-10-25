import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/components/dropdown2.dart';
import 'package:phd_discussion/provider/NavProvider/dropdownClass.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:reactive_forms/reactive_forms.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

final tagDropdownProvider = FutureProvider<List<Tag>>((ref) async {
  return getTagDropdown();
});

final categoriesDropdownProvider = FutureProvider<List<Category>>((ref) async {
  return getCategoriesDropdown();
});

final updateProfileProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await updateProfile(
    params['name']!,
    params['mobile']!,
    params['about']!,
    params['researchDetail']!,
  );
});
final updateTagProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  List<int> tagBytes = utf8.encode(params['tag']!);
  return await updateTag(tagBytes);
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool isTagSave = false;
  bool isCateSave = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController researchDetailsController;
  late TextEditingController descriptionController;
  String? selectedTags;
  String? newTagTitle;
  String? newTagDesc;
  String? selectedCate;
  String? newCateTitle;
  String? newCateDesc;
// Store selected tags
  final FormGroup form = FormGroup({
    'category': FormControl<List<String>>(validators: [Validators.required]),
    'tags': FormControl<List<String>>(validators: [Validators.required]),
  });
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    researchDetailsController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void _updateProfile() async {
    print(nameController.text);
    print(emailController.text);
    print(mobileController.text);
    print(descriptionController.text);
    print(researchDetailsController.text);
    final response = await ref.read(updateProfileProvider({
      'name': nameController.text,
      'mobile': mobileController.text,
      'about': descriptionController.text,
      'researchDetail': researchDetailsController.text,
    }).future);
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ref.refresh(profileProvider);
      Fluttertoast.showToast(msg: jsonResponse['message']);

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Error voting: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);
    ref.watch(tagProvider);
    final asyncTags = ref.watch(tagDropdownProvider);
    final asyncCateg = ref.watch(categoriesDropdownProvider);

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
              researchDetailsController.text = userData['research_detail'];

              // Safely extract tag IDs
              final List<dynamic> tags = userData['tags'];
              final List<dynamic> categories = userData['categories'];

              final List<String> defaultTagIds =
                  tags.map<String>((tag) => tag['id'].toString()).toList();
              final List<String> defaultCategoryIds = categories
                  .map<String>((category) => category['id'].toString())
                  .toList();

              // Assign values to the form controls
              form.control('tags').value = defaultTagIds;
              form.control('category').value = defaultCategoryIds;

              // Print to verify
              print("Default Tag IDs: $defaultTagIds");
              print("Default Category IDs: $defaultCategoryIds");
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
                      const Text(
                        'Interest ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      asyncTags.when(
                        data: (tags) {
                          final selectedTagsList = tags
                              .where((tag) =>
                                  form.control('tags').value.contains(tag.id))
                              .map((tag) => tag.brand)
                              .toList();

                          return CustomDropDown2(
                            items: tags.map((tag) => tag.brand).toList(),
                            icon: Icons.tag_rounded,
                            title: 'Tag',
                            maxSelections: 5,
                            initialValues: selectedTagsList,
                            onSelectionChanged: (selectedBrands) {
                              final selectedTagIds = tags
                                  .where((tag) =>
                                      selectedBrands.contains(tag.brand))
                                  .map((tag) => tag.id)
                                  .toList();

                              if (selectedTagIds.length <= 5) {
                                setState(() {
                                  selectedTags = selectedBrands.join(", ");
                                  form.control('tags').value = selectedTagIds;
                                  isTagSave = true;
                                  print("Selected Tag IDs: $selectedTagIds");
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "You can select up to 5 tags only")),
                                );
                              }
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text('Error: $error'),
                      ),
                      const SizedBox(height: 6),
                      if (isTagSave)
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                              onTap: () async {
                                final response =
                                    await ref.read(updateTagProvider({
                                  'tags': form.control('tags').value,
                                }).future);
                                final Map<String, dynamic> jsonResponse =
                                    jsonDecode(response.body);
                                print({'$jsonResponse.body'});
                                if (response.statusCode == 200) {
                                  ref.refresh(profileProvider);

                                  // Fluttertoast.showToast(
                                  //     msg: jsonResponse['message']);

                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Error voting: ${response.reasonPhrase}');
                                }
                              },
                              child: const Text(
                                'Save Tags',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      const Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      asyncCateg.when(
                        data: (categories) {
                          final selectedCategoriesList = categories
                              .where((category) => form
                                  .control('category')
                                  .value
                                  .contains(category.id))
                              .map((category) => category.category)
                              .toList();

                          return CustomDropDown2(
                            items: categories
                                .map((category) => category.category)
                                .toList(),
                            icon: Icons.badge,
                            title: 'Category',
                            initialValues: selectedCategoriesList,
                            onSelectionChanged: (selectedCategories) {
                              final selectedCategoryIds = categories
                                  .where((category) => selectedCategories
                                      .contains(category.category))
                                  .map((category) => category.id)
                                  .toList();

                              setState(() {
                                form.control('category').value =
                                    selectedCategoryIds;
                                isCateSave = true;
                                print(
                                    "Selected Category IDs: $selectedCategoryIds");
                              });
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text('Error: $error'),
                      ),
                      const SizedBox(height: 6),
                      if (isCateSave)
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                              onTap: () {},
                              child: const Text(
                                'Save Categories',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      const SizedBox(height: 20),
                      // _buildActionButtons(),
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
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Personal Information',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildProfileField('Name', nameController),
            const SizedBox(height: 8),
            _buildProfileField('Email', emailController),
            const SizedBox(height: 8),
            _buildProfileField('Mobile', mobileController),
            if (_isEditing) ...[
              const SizedBox(height: 8),
              _buildProfileField('Research Detail', researchDetailsController),
              const SizedBox(height: 8),
              _buildProfileField('About Me', descriptionController,
                  maxLines: 3),
              const SizedBox(height: 8),
              _isEditing
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        onTap: _updateProfile,
                        child: const Text(
                          'Save User Data',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
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
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blueGrey)),
        const SizedBox(height: 8),
        _isEditing
            ? TextFormField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter your $label',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.edit, color: Colors.blueGrey),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Text(controller.text,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 16)),
              ),
      ],
    );
  }
}
