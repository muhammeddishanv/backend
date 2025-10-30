/// User Progress Model
/// Represents user progress in a course/lesson from the backend API
class UserProgressModel {
  final String id;
  final String userId;
  final String courseId;
  final String lessonId;
  final bool isCompleted;
  final int? progress;
  final String? createdAt;
  final String? updatedAt;

  UserProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.lessonId,
    this.isCompleted = false,
    this.progress,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      id: json['\$id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      courseId: json['courseId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      progress: json['progress'],
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      if (progress != null) 'progress': progress,
    };
  }

  UserProgressModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? lessonId,
    bool? isCompleted,
    int? progress,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
