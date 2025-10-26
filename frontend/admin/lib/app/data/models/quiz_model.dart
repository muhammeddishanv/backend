/// Quiz Model
/// Represents a quiz entity from the backend API
class QuizModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int timeLimit;
  final int passingScore;
  final int attemptCount;
  final String? createdAt;
  final String? updatedAt;

  QuizModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.passingScore,
    this.attemptCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['\$id'] ?? json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timeLimit: json['timeLimit'] ?? 0,
      passingScore: json['passingScore'] ?? 0,
      attemptCount: json['attemptCount'] ?? 0,
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'passingScore': passingScore,
      'attemptCount': attemptCount,
    };
  }

  QuizModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? timeLimit,
    int? passingScore,
    int? attemptCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      passingScore: passingScore ?? this.passingScore,
      attemptCount: attemptCount ?? this.attemptCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
