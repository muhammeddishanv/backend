/// Quiz Question Model
/// Represents a quiz question entity from the backend API
class QuizQuestionModel {
  final String id;
  final String quizId;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int order;
  final String? createdAt;
  final String? updatedAt;

  QuizQuestionModel({
    required this.id,
    required this.quizId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['\$id'] ?? json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      question: json['question'] ?? '',
      options: json['options'] is List
          ? List<String>.from(json['options'])
          : [],
      correctAnswer: json['correctAnswer'] ?? '',
      order: json['order'] ?? 0,
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'order': order,
    };
  }

  QuizQuestionModel copyWith({
    String? id,
    String? quizId,
    String? question,
    List<String>? options,
    String? correctAnswer,
    int? order,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuizQuestionModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
