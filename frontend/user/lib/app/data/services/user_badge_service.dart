import '../models/user_badge_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// User Badge Service
/// Handles all user badge-related API operations
class UserBadgeService {
  final ApiClient _apiClient = ApiClient();

  /// Get user badges (optionally filtered by user)
  Future<ApiResponse<List<UserBadgeModel>>> getUserBadges({
    String? userId,
  }) async {
    String endpoint = userId != null
        ? ApiConfig.userBadgesByUser(userId)
        : ApiConfig.userBadges;

    final response = await _apiClient.get<List<UserBadgeModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => UserBadgeModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Award a badge to a user
  Future<ApiResponse<UserBadgeModel>> awardBadge(
    UserBadgeModel userBadge,
  ) async {
    final response = await _apiClient.post<UserBadgeModel>(
      ApiConfig.userBadges,
      body: userBadge.toJson(),
      fromJson: (data) => UserBadgeModel.fromJson(data),
    );

    return response;
  }
}
