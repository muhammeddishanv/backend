import '../models/course_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Course Service
/// Handles all course-related API operations
class CourseService {
  final ApiClient _apiClient = ApiClient();

  /// Get all courses
  Future<ApiResponse<List<CourseModel>>> getAllCourses({
    String? category,
    String? instructor,
  }) async {
    String endpoint = ApiConfig.courses;
    
    // Add query parameters if provided
    if (category != null || instructor != null) {
      final params = <String>[];
      if (category != null) params.add('category=$category');
      if (instructor != null) params.add('instructor=$instructor');
      endpoint += '?${params.join('&')}';
    }

    final response = await _apiClient.get<List<CourseModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => CourseModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Get course by ID
  Future<ApiResponse<CourseModel>> getCourseById(String id) async {
    final response = await _apiClient.get<CourseModel>(
      ApiConfig.courseById(id),
      fromJson: (data) => CourseModel.fromJson(data),
    );

    return response;
  }

  /// Create a new course
  Future<ApiResponse<CourseModel>> createCourse(CourseModel course) async {
    final response = await _apiClient.post<CourseModel>(
      ApiConfig.courses,
      body: course.toJson(),
      fromJson: (data) => CourseModel.fromJson(data),
    );

    return response;
  }

  /// Update a course
  Future<ApiResponse<CourseModel>> updateCourse(
    String id,
    CourseModel course,
  ) async {
    final response = await _apiClient.put<CourseModel>(
      ApiConfig.courseById(id),
      body: course.toJson(),
      fromJson: (data) => CourseModel.fromJson(data),
    );

    return response;
  }

  /// Delete a course
  Future<ApiResponse<Map<String, dynamic>>> deleteCourse(String id) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      ApiConfig.courseById(id),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return response;
  }
}
