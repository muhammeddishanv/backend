import '../models/quiz_question_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Quiz Question Service
/// Handles all quiz question-related API operations
class QuizQuestionService {
  final ApiClient _apiClient = ApiClient();

  /// Get all quiz questions (optionally filtered by quiz)
  Future<ApiResponse<List<QuizQuestionModel>>> getAllQuizQuestions({
    String? quizId,
  }) async {
    String endpoint = quizId != null
        ? ApiConfig.quizQuestionsByQuiz(quizId)
        : ApiConfig.quizQuestions;

    final response = await _apiClient.get<List<QuizQuestionModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => QuizQuestionModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Get quiz question by ID
  Future<ApiResponse<QuizQuestionModel>> getQuizQuestionById(String id) async {
    final response = await _apiClient.get<QuizQuestionModel>(
      ApiConfig.quizQuestionById(id),
      fromJson: (data) => QuizQuestionModel.fromJson(data),
    );

    return response;
  }

  /// Create a new quiz question
  Future<ApiResponse<QuizQuestionModel>> createQuizQuestion(
    QuizQuestionModel question,
  ) async {
    final response = await _apiClient.post<QuizQuestionModel>(
      ApiConfig.quizQuestions,
      body: question.toJson(),
      fromJson: (data) => QuizQuestionModel.fromJson(data),
    );

    return response;
  }

  /// Update a quiz question
  Future<ApiResponse<QuizQuestionModel>> updateQuizQuestion(
    String id,
    QuizQuestionModel question,
  ) async {
    final response = await _apiClient.put<QuizQuestionModel>(
      ApiConfig.quizQuestionById(id),
      body: question.toJson(),
      fromJson: (data) => QuizQuestionModel.fromJson(data),
    );

    return response;
  }

  /// Delete a quiz question
  Future<ApiResponse<Map<String, dynamic>>> deleteQuizQuestion(
    String id,
  ) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      ApiConfig.quizQuestionById(id),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return response;
  }
}
