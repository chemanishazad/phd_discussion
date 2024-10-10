import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: Text('Add New ${widget.heading}', textAlign: TextAlign.center),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                titleController,
                '${widget.heading} Title',
                Icons.label,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category title';
                  }
                  return null;
                },
              ),
              _buildTextField(
                descriptionController,
                '${widget.heading} Description',
                Icons.description,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category description';
                  }
                  return null;
                },
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            titleController.clear();
            descriptionController.clear();
            Navigator.pop(context);
          },
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();
              widget.onSave(title, description);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String?) validator, {
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
          errorStyle: const TextStyle(color: Colors.red),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }
}
