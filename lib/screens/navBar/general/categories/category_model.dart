// class Category {
//   final int id;
//   final String category;
//   final String image;
//   final String description;
//   final String metaDescription;
//   final String keywords;
//   final int parentId;
//   final int featured;
//   final int status;
//   final String addedOn;
//   final String modifiedOn;
//   final int companyId;
//   final String username;
//   final int modifiedBy;
//   final String seoUrl;
//   final List<Category>? children;

//   Category({
//     required this.id,
//     required this.category,
//     required this.image,
//     required this.description,
//     required this.metaDescription,
//     required this.keywords,
//     required this.parentId,
//     required this.featured,
//     required this.status,
//     required this.addedOn,
//     required this.modifiedOn,
//     required this.companyId,
//     required this.username,
//     required this.modifiedBy,
//     required this.seoUrl,
//     this.children,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     var childrenJson = json['children'] as List?;
//     List<Category>? childrenList = childrenJson != null
//         ? childrenJson.map((child) => Category.fromJson(child)).toList()
//         : null;

//     return Category(
//       id: json['id'],
//       category: json['category'],
//       image: json['image'] ?? '',
//       description: json['description'],
//       metaDescription: json['meta_description'],
//       keywords: json['keywords'],
//       parentId: json['parent_id'],
//       featured: json['featured'],
//       status: json['status'],
//       addedOn: json['added_on'],
//       modifiedOn: json['modify_on'],
//       companyId: json['company_id'],
//       username: json['username'],
//       modifiedBy: json['modify_by'],
//       seoUrl: json['seo_url'],
//       children: childrenList,
//     );
//   }
// }
