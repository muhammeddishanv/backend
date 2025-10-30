/// User Badge Model
/// Represents a user badge entity from the backend API
class UserBadgeModel {
  final String id;
  final String userId;
  final String badgeId;
  final String? earnedAt;
  final String? createdAt;
  final String? updatedAt;

  UserBadgeModel({
    required this.id,
    required this.userId,
    required this.badgeId,
    this.earnedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) {
    return UserBadgeModel(
      id: json['\$id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      badgeId: json['badgeId'] ?? '',
      earnedAt: json['earnedAt'],
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'badgeId': badgeId,
      if (earnedAt != null) 'earnedAt': earnedAt,
    };
  }

  UserBadgeModel copyWith({
    String? id,
    String? userId,
    String? badgeId,
    String? earnedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserBadgeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      badgeId: badgeId ?? this.badgeId,
      earnedAt: earnedAt ?? this.earnedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
