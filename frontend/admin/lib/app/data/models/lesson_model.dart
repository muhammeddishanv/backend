/// Lesson Model
/// Represents a lesson entity from the backend API
class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final int order;
  final int completionCount;
  final String? videoUrl;
  final String? createdAt;
  final String? updatedAt;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.order,
    this.completionCount = 0,
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['\$id'] ?? json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      order: json['order'] ?? 0,
      completionCount: json['completionCount'] ?? 0,
      videoUrl: json['videoUrl'],
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'content': content,
      'order': order,
      'completionCount': completionCount,
      if (videoUrl != null) 'videoUrl': videoUrl,
    };
  }

  LessonModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? content,
    int? order,
    int? completionCount,
    String? videoUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    return LessonModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      completionCount: completionCount ?? this.completionCount,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
