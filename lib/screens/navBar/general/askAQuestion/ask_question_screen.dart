import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/components/dropdown2.dart';
import 'package:phd_discussion/provider/NavProvider/model/withoutLoginQuestionSave.dart';
import 'package:phd_discussion/provider/NavProvider/navProvider.dart';
import 'package:phd_discussion/screens/navBar/general/askAQuestion/widgets/popup.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final QuillEditorController bodyController = QuillEditorController();
  String? selectedTags;
  String? selectedCate;
  String? newCateTitle;
  String? newCateDesc;
  String? newTagTitle;
  String? newTagDesc;

  final FormGroup form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'title': FormControl<String>(validators: [Validators.required]),
    'summary': FormControl<String>(validators: [Validators.required]),
    'body': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
    'category': FormControl<List<String>>(validators: [Validators.required]),
    'tags': FormControl<List<String>>(validators: [Validators.required]),
  });

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.size,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  @override
  Widget build(BuildContext context) {
    final asyncTags = ref.watch(tagDropdownProvider);
    final asyncCateg = ref.watch(categoriesDropdownProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ask a Question',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(tagDropdownProvider);
          await ref.refresh(categoriesDropdownProvider);
        },
        child: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('EMAIL'),
                  CustomReactiveTextField(
                    formControlName: 'email',
                    hintText: 'Enter Your Email',
                    prefixIcon: Icons.email_outlined,
                    validationMessages: {
                      'required': (control) => 'The email is required',
                      'email': (control) => 'Please enter a valid email',
                    },
                  ),
                  SizedBox(height: 2.h),
                  _title('TITLE'),
                  _subTitle(
                      "Be specific and imagine you're asking a question to another"),
                  CustomReactiveTextField(
                    formControlName: 'title',
                    hintText: 'Type the title here!',
                    prefixIcon: Icons.title,
                    validationMessages: {
                      'required': (control) => 'The title is required',
                    },
                  ),
                  SizedBox(height: 2.h),
                  _title('SUMMARY/OVERVIEW'),
                  _subTitle(
                      "Summarize your question or write about your question"),
                  CustomReactiveTextField(
                    formControlName: 'summary',
                    hintText: 'Type the summary here!',
                    prefixIcon: Icons.comment,
                    validationMessages: {
                      'required': (control) => 'The summary is required',
                    },
                  ),
                  SizedBox(height: 2.h),
                  _title('BODY'),
                  _subTitle(
                      "Include all the information someone would need to answer your question"),
                  _buildCard(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: ToolBar(
                            controller: bodyController,
                            toolBarConfig: customToolBarList,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        QuillHtmlEditor(
                          hintText: 'Type your question details here...',
                          controller: bodyController,
                          isEnabled: true,
                          minHeight: 300,
                          hintTextAlign: TextAlign.start,
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          hintTextPadding: EdgeInsets.zero,
                          loadingBuilder: (context) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 0.4));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _title('Category'),
                  _subTitle(
                      "Select Question Category (You can choose multiple)"),
                  asyncCateg.when(
                    data: (categories) {
                      return CustomDropDown2(
                        items: categories
                            .map((category) => category.category)
                            .toList(),
                        icon: Icons.badge,
                        title: 'Category',
                        initialValues: [],
                        onSelectionChanged: (selectedCategories) {
                          final selectedCategoryIds = categories
                              .where((category) => selectedCategories
                                  .contains(category.category))
                              .map((category) => category.id)
                              .toList();

                          setState(() {
                            form.control('category').value =
                                selectedCategoryIds;
                            print(
                                "Selected Category IDs: $selectedCategoryIds");
                          });
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Error: $error'),
                  ),
                  SizedBox(height: 1.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          _showAddCategoryDialog(context);
                        },
                        child: const Text('Add new category')),
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
                        initialValues: [],
                        onSelectionChanged: (selectedBrands) {
                          final selectedTagIds = tags
                              .where(
                                  (tag) => selectedBrands.contains(tag.brand))
                              .map((tag) => tag.id)
                              .toList();

                          if (selectedTagIds.length <= 5) {
                            setState(() {
                              selectedTags = selectedBrands.join(", ");
                              form.control('tags').value = selectedTagIds;
                              print("Selected Tag IDs: $selectedTagIds");
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          _showAddTagDialog(context);
                        },
                        child: const Text('Add new Tag')),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      onTap: () async {
                        String? bodyContent = await bodyController.getText();
                        SaveQuestionWLogin question = SaveQuestionWLogin(
                          email: form.control('email').value,
                          title: form.control('title').value,
                          subTitle: form.control('summary').value,
                          body: bodyContent,
                          category: form.control('category').value,
                          tags: form.control('tags').value,
                          createNewTag: (newTagTitle?.isNotEmpty ?? false),
                          newTagName: newTagTitle ?? '',
                          newTagDescription: newTagDesc ?? '',
                          createNewCategory:
                              (newCateTitle?.isNotEmpty ?? false),
                          newCategoryName: newCateTitle ?? '',
                          newCategoryDescription: newCateDesc ?? '',
                        );

                        _printQuestionData(question);
                        try {
                          final responseData =
                              await postQuestionWithout(question);
                          final String message = responseData['message'];
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );

                          Navigator.of(context).pushReplacementNamed('/home');

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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _printQuestionData(SaveQuestionWLogin question) {
    print('Email: ${question.email}');
    print('Title: ${question.title}');
    print('Summary: ${question.subTitle}');
    print('Body: ${question.body}');
    print('Category IDs: ${question.category}');
    print('Tag IDs: ${question.tags}');
    print('Create New Tag: ${question.createNewTag}');
    print('New Tag Name: ${question.newTagName}');
    print('New Tag Description: ${question.newTagDescription}');
    print('Create New Category: ${question.createNewCategory}');
    print('New Category Name: ${question.newCategoryName}');
    print('New Category Description: ${question.newCategoryDescription}');
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomCategoryDialog(
          heading: 'Category',
          title: '',
          description: '',
          onSave: (title, description) {
            setState(() {
              newCateTitle = title;
              newCateDesc = description;
            });
            print('Category Title: $newCateTitle');
            print('Category Description: $newCateDesc');
          },
        );
      },
    );
  }

  void _showAddTagDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomCategoryDialog(
          heading: 'Tag',
          title: '',
          description: '',
          onSave: (title, description) {
            setState(() {
              newTagTitle = title;
              newTagDesc = description;
            });
            print('Category Title: $newCateTitle');
            print('Category Description: $newCateDesc');
          },
        );
      },
    );
  }

  Widget _buildCard({String? subTitle, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subTitle != null) _subTitle(subTitle),
            const SizedBox(height: 8),
            child,
          ],
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
