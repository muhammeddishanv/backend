// Controller for Admin Subject Management.
// Responsibilities: manage subject list state, editing flags and API interactions.
// Put network/fetching logic and transformation here; keep the view focused on UI.

import 'package:get/get.dart';
import '../../../data/models/course_model.dart';
import '../../../data/services/course_service.dart';

class AdminSubjectManagementController extends GetxController {
  final CourseService _courseService = CourseService();

  // Observable list of courses (subjects)
  final RxList<CourseModel> courses = <CourseModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load courses when controller is initialized
    loadCourses();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose resources if needed
    super.onClose();
  }

  /// Load all courses from the backend
  Future<void> loadCourses({String? category, String? instructor}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _courseService.getAllCourses(
        category: category,
        instructor: instructor,
      );

      if (response.success && response.data != null) {
        courses.value = response.data!;
      } else {
        errorMessage.value = response.error ?? 'Failed to load courses';
      }
    } catch (e) {
      errorMessage.value = 'Error loading courses: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Get a specific course by ID
  Future<CourseModel?> getCourseById(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _courseService.getCourseById(id);

      if (response.success && response.data != null) {
        return response.data;
      } else {
        errorMessage.value = response.error ?? 'Failed to load course';
        return null;
      }
    } catch (e) {
      errorMessage.value = 'Error loading course: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new course
  Future<bool> createCourse(CourseModel course) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _courseService.createCourse(course);

      if (response.success && response.data != null) {
        courses.add(response.data!);
        Get.snackbar('Success', 'Course created successfully');
        return true;
      } else {
        errorMessage.value = response.error ?? 'Failed to create course';
        Get.snackbar('Error', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error creating course: $e';
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing course
  Future<bool> updateCourse(String id, CourseModel course) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _courseService.updateCourse(id, course);

      if (response.success && response.data != null) {
        final index = courses.indexWhere((c) => c.id == id);
        if (index != -1) {
          courses[index] = response.data!;
        }
        Get.snackbar('Success', 'Course updated successfully');
        return true;
      } else {
        errorMessage.value = response.error ?? 'Failed to update course';
        Get.snackbar('Error', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error updating course: $e';
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a course
  Future<bool> deleteCourse(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _courseService.deleteCourse(id);

      if (response.success) {
        courses.removeWhere((c) => c.id == id);
        Get.snackbar('Success', 'Course deleted successfully');
        return true;
      } else {
        errorMessage.value = response.error ?? 'Failed to delete course';
        Get.snackbar('Error', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error deleting course: $e';
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
