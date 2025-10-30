import '../models/lesson_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Lesson Service
/// Handles all lesson-related API operations
class LessonService {
  final ApiClient _apiClient = ApiClient();

  /// Get all lessons (optionally filtered by course)
  Future<ApiResponse<List<LessonModel>>> getAllLessons({
    String? courseId,
  }) async {
    String endpoint = courseId != null
        ? ApiConfig.lessonsByCourse(courseId)
        : ApiConfig.lessons;

    final response = await _apiClient.get<List<LessonModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => LessonModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Get lesson by ID
  Future<ApiResponse<LessonModel>> getLessonById(String id) async {
    final response = await _apiClient.get<LessonModel>(
      ApiConfig.lessonById(id),
      fromJson: (data) => LessonModel.fromJson(data),
    );

    return response;
  }

  /// Create a new lesson
  Future<ApiResponse<LessonModel>> createLesson(LessonModel lesson) async {
    final response = await _apiClient.post<LessonModel>(
      ApiConfig.lessons,
      body: lesson.toJson(),
      fromJson: (data) => LessonModel.fromJson(data),
    );

    return response;
  }

  /// Update a lesson
  Future<ApiResponse<LessonModel>> updateLesson(
    String id,
    LessonModel lesson,
  ) async {
    final response = await _apiClient.put<LessonModel>(
      ApiConfig.lessonById(id),
      body: lesson.toJson(),
      fromJson: (data) => LessonModel.fromJson(data),
    );

    return response;
  }

  /// Delete a lesson
  Future<ApiResponse<Map<String, dynamic>>> deleteLesson(String id) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      ApiConfig.lessonById(id),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return response;
  }
}
