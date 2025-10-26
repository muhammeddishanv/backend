import '../models/quiz_attempt_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Quiz Attempt Service
/// Handles all quiz attempt-related API operations
class QuizAttemptService {
  final ApiClient _apiClient = ApiClient();

  /// Get quiz attempts (optionally filtered by user and/or quiz)
  Future<ApiResponse<List<QuizAttemptModel>>> getQuizAttempts({
    String? userId,
    String? quizId,
  }) async {
    String endpoint = ApiConfig.quizAttempts;
    
    if (userId != null && quizId != null) {
      endpoint = ApiConfig.quizAttemptsByQuiz(userId, quizId);
    } else if (userId != null) {
      endpoint = ApiConfig.quizAttemptsByUser(userId);
    }

    final response = await _apiClient.get<List<QuizAttemptModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => QuizAttemptModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Submit a quiz attempt
  Future<ApiResponse<QuizAttemptModel>> submitQuizAttempt(
    QuizAttemptModel attempt,
  ) async {
    final response = await _apiClient.post<QuizAttemptModel>(
      ApiConfig.quizAttempts,
      body: attempt.toJson(),
      fromJson: (data) => QuizAttemptModel.fromJson(data),
    );

    return response;
  }
}
