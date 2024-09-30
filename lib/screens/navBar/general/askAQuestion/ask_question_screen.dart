import 'package:flutter/material.dart';
import 'package:phd_discussion/core/TextField.dart/reactive_textfield.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionStateScreen();
}

class _AskQuestionStateScreen extends State<AskQuestionScreen> {
  final QuillEditorController bodyController = QuillEditorController();

  final FormGroup form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'title': FormControl<String>(validators: [Validators.required]),
    'summary': FormControl<String>(validators: [Validators.required]),
    'body': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
    'category': FormControl<String>(validators: [Validators.required]),
    'tags': FormControl<String>(validators: [Validators.required]),
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
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ask a Question',
      ),
      body: ReactiveForm(
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
                      const SizedBox(height: 8),
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
                            strokeWidth: 0.4,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
