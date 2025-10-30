import '../models/user_progress_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// User Progress Service
/// Handles all user progress-related API operations
class UserProgressService {
  final ApiClient _apiClient = ApiClient();

  /// Get user progress (optionally filtered by user and/or course)
  Future<ApiResponse<List<UserProgressModel>>> getUserProgress({
    String? userId,
    String? courseId,
  }) async {
    String endpoint = ApiConfig.progress;
    
    if (userId != null && courseId != null) {
      endpoint = ApiConfig.progressByCourse(userId, courseId);
    } else if (userId != null) {
      endpoint = ApiConfig.progressByUser(userId);
    }

    final response = await _apiClient.get<List<UserProgressModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => UserProgressModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Create or update user progress
  Future<ApiResponse<UserProgressModel>> saveProgress(
    UserProgressModel progress,
  ) async {
    final response = await _apiClient.post<UserProgressModel>(
      ApiConfig.progress,
      body: progress.toJson(),
      fromJson: (data) => UserProgressModel.fromJson(data),
    );

    return response;
  }
}
