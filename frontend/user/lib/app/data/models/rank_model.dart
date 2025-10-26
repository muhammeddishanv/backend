/// Rank Model
/// Represents a rank entity from the backend API
class RankModel {
  final String id;
  final String userId;
  final String courseId;
  final int score;
  final int rank;
  final String? achievedAt;
  final String? createdAt;
  final String? updatedAt;

  RankModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.score,
    required this.rank,
    this.achievedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) {
    return RankModel(
      id: json['\$id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      courseId: json['courseId'] ?? '',
      score: json['score'] ?? 0,
      rank: json['rank'] ?? 0,
      achievedAt: json['achievedAt'],
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'score': score,
      'rank': rank,
      if (achievedAt != null) 'achievedAt': achievedAt,
    };
  }

  RankModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    int? score,
    int? rank,
    String? achievedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return RankModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      achievedAt: achievedAt ?? this.achievedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
