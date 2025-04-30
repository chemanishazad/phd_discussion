import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/components/dropdown2.dart';
import 'package:phd_discussion/provider/NavProvider/dropdownClass.dart';
import 'package:phd_discussion/provider/NavProvider/model/editQuestionApiModel.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final tagDropdownProvider = FutureProvider<List<Tag>>((ref) async {
  return getTagDropdown();
});

final categoriesDropdownProvider = FutureProvider<List<Category>>((ref) async {
  return getCategoriesDropdown();
});

class EditQuestionScreen extends ConsumerStatefulWidget {
  const EditQuestionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditQuestionScreenState();
}

class _EditQuestionScreenState extends ConsumerState<EditQuestionScreen> {
  late final HtmlEditorController bodyController;
  String? selectedTags;
  String? selectedCate;

  final FormGroup form = FormGroup({
    'id': FormControl<String>(),
    'email': FormControl<String>(validators: [Validators.email]),
    'title': FormControl<String>(validators: [Validators.required]),
    'summary': FormControl<String>(validators: [Validators.required]),
    'body': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
    'category': FormControl<List<String>>(validators: [Validators.required]),
    'tags': FormControl<List<String>>(validators: [Validators.required]),
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final question =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print(question);
    if (question != null) {
      form.control('id').value = question['id'] ?? '';
      form.control('title').value = question['title'] ?? '';
      form.control('summary').value = question['sub_title'] ?? '';

      form.control('tags').value = (question['tags'] as List<dynamic>?)
              ?.map((tag) => tag['id'].toString())
              .toList() ??
          [];

      form.control('category').value = (question['category'] as List<dynamic>?)
              ?.map((cat) => cat['id'].toString())
              .toList() ??
          [];

      bodyController.setText(question['body'] ?? '');
      form.control('body').value = question['body'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncTags = ref.watch(tagDropdownProvider);
    final asyncCateg = ref.watch(categoriesDropdownProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: ('Edit Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveTextField<String>(
                  formControlName: 'title',
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ReactiveTextField<String>(
                  formControlName: 'summary',
                  decoration: InputDecoration(
                    labelText: 'Summary',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Body'),
                HtmlEditor(
                  controller: bodyController,
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: "Add comment for Basic plan",
                  ),
                  otherOptions: const OtherOptions(
                    height: 300,
                  ),
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    defaultToolbarButtons: [
                      FontButtons(clearAll: false),
                      ParagraphButtons(
                        alignCenter: true,
                        alignLeft: true,
                        alignRight: true,
                        lineHeight: false,
                        textDirection: false,
                      ),
                      InsertButtons(table: false, video: false, audio: false),
                    ],
                  ),
                ),
                _title('Category'),
                _subTitle("Select Question Category (You can choose multiple)"),
                asyncCateg.when(
                  data: (categories) {
                    return CustomDropDown2(
                      items: categories
                          .map((category) => category.category)
                          .toList(),
                      icon: Icons.badge,
                      title: 'Category',
                      initialValues: form
                          .control('category')
                          .value
                          .map((id) => categories
                              .firstWhere((cat) => cat.id.toString() == id)
                              .category)
                          .toList()
                          .cast<String>(),
                      onSelectionChanged: (selectedCategories) {
                        final selectedCategoryIds = categories
                            .where((category) =>
                                selectedCategories.contains(category.category))
                            .map((category) => category.id.toString())
                            .toList();

                        setState(() {
                          form.control('category').value = selectedCategoryIds;
                          print("Selected Category IDs: $selectedCategoryIds");
                        });
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
                _title('Tags'),
                _subTitle(
                    "Add up to 5 tags to describe your question is about"),
                asyncTags.when(
                  data: (tags) {
                    return CustomDropDown2(
                      items: tags.map((tag) => tag.brand).toList(),
                      icon: Icons.tag_rounded,
                      title: 'Tag',
                      maxSelections: 5,
                      initialValues: form
                          .control('tags')
                          .value
                          .map((id) => tags
                              .firstWhere((tag) => tag.id.toString() == id)
                              .brand)
                          .toList()
                          .cast<String>(),
                      onSelectionChanged: (selectedBrands) {
                        final selectedTagIds = tags
                            .where((tag) => selectedBrands.contains(tag.brand))
                            .map((tag) => tag.id.toString())
                            .toList();

                        if (selectedTagIds.length <= 5) {
                          setState(() {
                            form.control('tags').value = selectedTagIds;
                            print(
                                "Selected Tag IDs: ${form.control('tags').value}");
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("You can select up to 5 tags only")),
                          );
                        }
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                      onTap: () async {
                        String? bodyContent = await bodyController.getText();
                        form.markAllAsTouched();
                        EditQuestionModel question = EditQuestionModel(
                          id: form.control('id').value,
                          title: form.control('title').value,
                          subTitle: form.control('summary').value,
                          body: bodyContent,
                          category: form.control('category').value,
                          tags: form.control('tags').value,
                        );
                        print(question.title);
                        print(question.body);
                        print(question.id);
                        print(question.subTitle);
                        print(question.tags);
                        print(question.category);
                        try {
                          final responseData = await editQuestion(question);
                          final String message = responseData['message'];
                          print('message$message');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );

                          Navigator.pop(context);

                          print("Question saved successfully");
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Error saving question. Please try again.")));
                          print("Error saving question: $e");
                        }
                      },
                      child: const Text(
                        'Save Question',
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _subTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
