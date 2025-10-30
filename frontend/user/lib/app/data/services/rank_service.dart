import '../models/rank_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Rank Service
/// Handles all rank-related API operations
class RankService {
  final ApiClient _apiClient = ApiClient();

  /// Get ranks (optionally filtered by course)
  Future<ApiResponse<List<RankModel>>> getRanks({
    String? courseId,
  }) async {
    String endpoint = courseId != null
        ? ApiConfig.ranksByCourse(courseId)
        : ApiConfig.ranks;

    final response = await _apiClient.get<List<RankModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => RankModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Create a new rank
  Future<ApiResponse<RankModel>> createRank(RankModel rank) async {
    final response = await _apiClient.post<RankModel>(
      ApiConfig.ranks,
      body: rank.toJson(),
      fromJson: (data) => RankModel.fromJson(data),
    );

    return response;
  }
}
