/// Quiz Attempt Model
/// Represents a quiz attempt from the backend API
class QuizAttemptModel {
  final String id;
  final String userId;
  final String quizId;
  final Map<String, dynamic> answers;
  final int score;
  final int totalQuestions;
  final int passingScore;
  final bool passed;
  final String? attemptedAt;
  final String? createdAt;
  final String? updatedAt;

  QuizAttemptModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.answers,
    required this.score,
    required this.totalQuestions,
    required this.passingScore,
    required this.passed,
    this.attemptedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['\$id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      quizId: json['quizId'] ?? '',
      answers: json['answers'] is Map
          ? Map<String, dynamic>.from(json['answers'])
          : {},
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      passingScore: json['passingScore'] ?? 0,
      passed: json['passed'] ?? false,
      attemptedAt: json['attemptedAt'],
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'quizId': quizId,
      'answers': answers,
      'score': score,
      'totalQuestions': totalQuestions,
      'passingScore': passingScore,
      'passed': passed,
      if (attemptedAt != null) 'attemptedAt': attemptedAt,
    };
  }

  QuizAttemptModel copyWith({
    String? id,
    String? userId,
    String? quizId,
    Map<String, dynamic>? answers,
    int? score,
    int? totalQuestions,
    int? passingScore,
    bool? passed,
    String? attemptedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuizAttemptModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      quizId: quizId ?? this.quizId,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      passingScore: passingScore ?? this.passingScore,
      passed: passed ?? this.passed,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
