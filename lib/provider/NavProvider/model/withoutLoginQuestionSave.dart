class SaveQuestionWLogin {
  final String? email;
  final String title;
  final String? subTitle;
  final String? body;
  final List<String>? tags;
  final List<String>? category;
  final bool? createNewTag;
  final String? newTagName;
  final String? newTagDescription;
  final bool? createNewCategory;
  final String? newCategoryName;
  final String? newCategoryDescription;

  SaveQuestionWLogin({
    this.email,
    required this.title,
    this.subTitle,
    this.body,
    this.tags,
    this.category,
    this.createNewTag,
    this.newTagName,
    this.newTagDescription,
    this.createNewCategory,
    this.newCategoryName,
    this.newCategoryDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'title': title,
      'sub_title': subTitle,
      'body': body,
      'tags': tags,
      'category': category,
      'create_new_tag': createNewTag,
      'new_tag_name': newTagName,
      'new_tag_description': newTagDescription,
      'create_new_category': createNewCategory,
      'new_category_name': newCategoryName,
      'new_category_description': newCategoryDescription,
    };
  }
}
