import '../models/badge_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Badge Service
/// Handles all badge-related API operations
class BadgeService {
  final ApiClient _apiClient = ApiClient();

  /// Get all badges
  Future<ApiResponse<List<BadgeModel>>> getAllBadges() async {
    final response = await _apiClient.get<List<BadgeModel>>(
      ApiConfig.badges,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => BadgeModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Get badge by ID
  Future<ApiResponse<BadgeModel>> getBadgeById(String id) async {
    final response = await _apiClient.get<BadgeModel>(
      ApiConfig.badgeById(id),
      fromJson: (data) => BadgeModel.fromJson(data),
    );

    return response;
  }

  /// Create a new badge
  Future<ApiResponse<BadgeModel>> createBadge(BadgeModel badge) async {
    final response = await _apiClient.post<BadgeModel>(
      ApiConfig.badges,
      body: badge.toJson(),
      fromJson: (data) => BadgeModel.fromJson(data),
    );

    return response;
  }
}
