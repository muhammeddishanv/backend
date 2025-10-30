import '../models/quiz_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Quiz Service
/// Handles all quiz-related API operations
class QuizService {
  final ApiClient _apiClient = ApiClient();

  /// Get all quizzes (optionally filtered by course)
  Future<ApiResponse<List<QuizModel>>> getAllQuizzes({
    String? courseId,
  }) async {
    String endpoint = courseId != null
        ? ApiConfig.quizzesByCourse(courseId)
        : ApiConfig.quizzes;

    final response = await _apiClient.get<List<QuizModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => QuizModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Get quiz by ID
  Future<ApiResponse<QuizModel>> getQuizById(String id) async {
    final response = await _apiClient.get<QuizModel>(
      ApiConfig.quizById(id),
      fromJson: (data) => QuizModel.fromJson(data),
    );

    return response;
  }

  /// Create a new quiz
  Future<ApiResponse<QuizModel>> createQuiz(QuizModel quiz) async {
    final response = await _apiClient.post<QuizModel>(
      ApiConfig.quizzes,
      body: quiz.toJson(),
      fromJson: (data) => QuizModel.fromJson(data),
    );

    return response;
  }

  /// Update a quiz
  Future<ApiResponse<QuizModel>> updateQuiz(
    String id,
    QuizModel quiz,
  ) async {
    final response = await _apiClient.put<QuizModel>(
      ApiConfig.quizById(id),
      body: quiz.toJson(),
      fromJson: (data) => QuizModel.fromJson(data),
    );

    return response;
  }

  /// Delete a quiz
  Future<ApiResponse<Map<String, dynamic>>> deleteQuiz(String id) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      ApiConfig.quizById(id),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return response;
  }
}
