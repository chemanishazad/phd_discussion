class Tag {
  final String id;
  final String brand;

  Tag({required this.id, required this.brand});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      brand: json['brand'] as String,
    );
  }
}

class Category {
  final String id;
  final String category;

  Category({required this.id, required this.category});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      category: json['category'] as String,
    );
  }
}
