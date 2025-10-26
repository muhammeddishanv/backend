/// Badge Model
/// Represents a badge entity from the backend API
class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String criteria;
  final String icon;
  final String? createdAt;
  final String? updatedAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.criteria,
    required this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['\$id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      criteria: json['criteria'] ?? '',
      icon: json['icon'] ?? '',
      createdAt: json['\$createdAt'] ?? json['createdAt'],
      updatedAt: json['\$updatedAt'] ?? json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'criteria': criteria,
      'icon': icon,
    };
  }

  BadgeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? criteria,
    String? icon,
    String? createdAt,
    String? updatedAt,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      criteria: criteria ?? this.criteria,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
