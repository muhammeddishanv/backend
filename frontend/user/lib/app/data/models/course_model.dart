/// Course Model
/// Represents a course entity from the backend API
class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String category;
  final double price;
  final int enrollmentCount;
  final bool isPublished;
  final String? createdAt;
  final String? updatedAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.category,
    required this.price,
    this.enrollmentCount = 0,
    this.isPublished = false,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['\$id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructorId: json['instructorId'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      enrollmentCount: json['enrollmentCount'] ?? 0,
      isPublished: json['isPublished'] ?? false,
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'category': category,
      'price': price,
      'enrollmentCount': enrollmentCount,
      'isPublished': isPublished,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? instructorId,
    String? category,
    double? price,
    int? enrollmentCount,
    bool? isPublished,
    String? createdAt,
    String? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructorId: instructorId ?? this.instructorId,
      category: category ?? this.category,
      price: price ?? this.price,
      enrollmentCount: enrollmentCount ?? this.enrollmentCount,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
