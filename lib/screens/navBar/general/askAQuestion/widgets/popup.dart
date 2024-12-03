import 'package:flutter/material.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/styles.dart';

class CustomCategoryDialog extends StatefulWidget {
  final String? title;
  final String heading;
  final String? description;
  final Function(String title, String description) onSave;

  const CustomCategoryDialog({
    Key? key,
    required this.onSave,
    this.title,
    this.description,
    required this.heading,
  }) : super(key: key);

  @override
  _CustomCategoryDialogState createState() => _CustomCategoryDialogState();
}

class _CustomCategoryDialogState extends State<CustomCategoryDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title ?? '');
    descriptionController =
        TextEditingController(text: widget.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: cardDecoration(
        context: context,
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            'Add New ${widget.heading}',
            style: Theme.of(context).textTheme.titleSmall,
          )),
          SizedBox(height: 15),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: titleController,
                  label: '${widget.heading} Title',
                  icon: Icons.label,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category title';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: descriptionController,
                  label: '${widget.heading} Description',
                  icon: Icons.description,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Clear',
                    style: TextStyle(fontSize: 14, color: Colors.red)),
              ),
              CustomButton(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();
                    widget.onSave(title, description);
                    Navigator.pop(context);
                  }
                },
                color: Colors.blueAccent,
                child:
                    Text('Save', style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: cardDecoration(context: context),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          maxLines: maxLines ?? 1,
          validator: validator,
        ),
      ),
    );
  }
}
