class EditQuestionModel {
  final String? id;
  final String title;
  final String? subTitle;
  final String? body;
  final List<String>? tags;
  final List<String>? category;

  EditQuestionModel({
    this.id,
    required this.title,
    this.subTitle,
    this.body,
    this.tags,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': id,
      'title': title,
      'sub_title': subTitle,
      'body': body,
      'tags': tags,
      'category': category,
    };
  }
}
