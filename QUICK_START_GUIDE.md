# Quick Start Guide - API Integration

## Setup Checklist

### 1. Configure API Base URL
File: `lib/app/config/api_config.dart`

```dart
static const String baseUrl = 'YOUR_APPWRITE_FUNCTION_URL';
```

### 2. Install Dependencies
```bash
cd frontend/admin
flutter pub get

cd ../user
flutter pub get
```

### 3. Import Required Files in Your Controller

```dart
// Import models you need
import '../../../data/models/course_model.dart';
import '../../../data/models/lesson_model.dart';

// Import services you need
import '../../../data/services/course_service.dart';
import '../../../data/services/lesson_service.dart';
```

## Common Patterns

### Pattern 1: Loading Data on Init

```dart
class MyController extends GetxController {
  final CourseService _courseService = CourseService();
  final RxList<CourseModel> courses = <CourseModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  Future<void> loadCourses() async {
    isLoading.value = true;
    
    final response = await _courseService.getAllCourses();
    
    if (response.success && response.data != null) {
      courses.value = response.data!;
    } else {
      Get.snackbar('Error', response.error ?? 'Failed to load');
    }
    
    isLoading.value = false;
  }
}
```

### Pattern 2: Creating New Record

```dart
Future<bool> createCourse(String title, String description, ...) async {
  isLoading.value = true;
  
  final newCourse = CourseModel(
    id: '', // Backend will generate
    title: title,
    description: description,
    instructorId: currentUserId,
    category: selectedCategory,
    price: price,
  );
  
  final response = await _courseService.createCourse(newCourse);
  
  if (response.success && response.data != null) {
    courses.add(response.data!);
    Get.snackbar('Success', 'Course created');
    isLoading.value = false;
    return true;
  }
  
  Get.snackbar('Error', response.error ?? 'Failed');
  isLoading.value = false;
  return false;
}
```

### Pattern 3: Updating Record

```dart
Future<bool> updateCourse(String id, Map<String, dynamic> updates) async {
  isLoading.value = true;
  
  // Get existing course
  final existing = courses.firstWhere((c) => c.id == id);
  
  // Create updated course
  final updated = existing.copyWith(
    title: updates['title'] ?? existing.title,
    description: updates['description'] ?? existing.description,
    // ... other fields
  );
  
  final response = await _courseService.updateCourse(id, updated);
  
  if (response.success && response.data != null) {
    final index = courses.indexWhere((c) => c.id == id);
    courses[index] = response.data!;
    Get.snackbar('Success', 'Course updated');
    isLoading.value = false;
    return true;
  }
  
  Get.snackbar('Error', response.error ?? 'Failed');
  isLoading.value = false;
  return false;
}
```

### Pattern 4: Deleting Record

```dart
Future<bool> deleteCourse(String id) async {
  isLoading.value = true;
  
  final response = await _courseService.deleteCourse(id);
  
  if (response.success) {
    courses.removeWhere((c) => c.id == id);
    Get.snackbar('Success', 'Course deleted');
    isLoading.value = false;
    return true;
  }
  
  Get.snackbar('Error', response.error ?? 'Failed');
  isLoading.value = false;
  return false;
}
```

### Pattern 5: Filtering Data

```dart
Future<void> loadCoursesByCategory(String category) async {
  isLoading.value = true;
  
  final response = await _courseService.getAllCourses(
    category: category,
  );
  
  if (response.success && response.data != null) {
    courses.value = response.data!;
  }
  
  isLoading.value = false;
}
```

### Pattern 6: Loading Related Data

```dart
// Load course with its lessons
Future<void> loadCourseDetails(String courseId) async {
  isLoading.value = true;
  
  final courseResponse = await _courseService.getCourseById(courseId);
  final lessonsResponse = await _lessonService.getAllLessons(
    courseId: courseId,
  );
  
  if (courseResponse.success && courseResponse.data != null) {
    currentCourse.value = courseResponse.data;
  }
  
  if (lessonsResponse.success && lessonsResponse.data != null) {
    lessons.value = lessonsResponse.data!;
  }
  
  isLoading.value = false;
}
```

## View Integration (No UI Changes)

### Display Loading State

```dart
Obx(() => controller.isLoading.value
  ? CircularProgressIndicator()
  : YourContentWidget()
)
```

### Display Data List

```dart
Obx(() => ListView.builder(
  itemCount: controller.courses.length,
  itemBuilder: (context, index) {
    final course = controller.courses[index];
    return ListTile(
      title: Text(course.title),
      subtitle: Text(course.description),
    );
  },
))
```

### Call Controller Methods

```dart
ElevatedButton(
  onPressed: () async {
    await controller.createCourse(title, description, ...);
  },
  child: Text('Create Course'),
)
```

## Available Services

### CourseService
```dart
final _courseService = CourseService();
await _courseService.getAllCourses({category, instructor});
await _courseService.getCourseById(id);
await _courseService.createCourse(course);
await _courseService.updateCourse(id, course);
await _courseService.deleteCourse(id);
```

### LessonService
```dart
final _lessonService = LessonService();
await _lessonService.getAllLessons({courseId});
await _lessonService.getLessonById(id);
await _lessonService.createLesson(lesson);
await _lessonService.updateLesson(id, lesson);
await _lessonService.deleteLesson(id);
```

### QuizService
```dart
final _quizService = QuizService();
await _quizService.getAllQuizzes({courseId});
await _quizService.getQuizById(id);
await _quizService.createQuiz(quiz);
await _quizService.updateQuiz(id, quiz);
await _quizService.deleteQuiz(id);
```

### QuizQuestionService
```dart
final _questionService = QuizQuestionService();
await _questionService.getAllQuizQuestions({quizId});
await _questionService.createQuizQuestion(question);
await _questionService.updateQuizQuestion(id, question);
await _questionService.deleteQuizQuestion(id);
```

### UserProgressService
```dart
final _progressService = UserProgressService();
await _progressService.getUserProgress({userId, courseId});
await _progressService.saveProgress(progress);
```

### QuizAttemptService
```dart
final _attemptService = QuizAttemptService();
await _attemptService.getQuizAttempts({userId, quizId});
await _attemptService.submitQuizAttempt(attempt);
```

### TransactionService
```dart
final _transactionService = TransactionService();
await _transactionService.getTransactions({userId});
await _transactionService.createTransaction(transaction);
```

### RankService
```dart
final _rankService = RankService();
await _rankService.getRanks({courseId});
await _rankService.createRank(rank);
```

### BadgeService
```dart
final _badgeService = BadgeService();
await _badgeService.getAllBadges();
await _badgeService.getBadgeById(id);
await _badgeService.createBadge(badge);
```

### UserBadgeService
```dart
final _userBadgeService = UserBadgeService();
await _userBadgeService.getUserBadges({userId});
await _userBadgeService.awardBadge(userBadge);
```

### NotificationService
```dart
final _notificationService = NotificationService();
await _notificationService.getNotifications({userId});
await _notificationService.createNotification(notification);
await _notificationService.markAsRead(id);
```

## Testing Checklist

- [ ] API base URL configured
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Controller imports services and models
- [ ] Loading states implemented
- [ ] Error handling implemented
- [ ] Success feedback (snackbars) implemented
- [ ] Data displays in UI
- [ ] Create operations work
- [ ] Update operations work
- [ ] Delete operations work
- [ ] Filtering works (if applicable)

## Common Errors

### "Target of URI doesn't exist"
- Check import paths are correct
- Ensure file exists at the path
- Use `../../config/api_config.dart` for services

### "Undefined name 'ApiConfig'"
- Import `api_config.dart` in your service
- Check the import path

### "Connection refused" or timeout
- Verify `baseUrl` in `api_config.dart`
- Check if backend is running
- Check network connectivity

### "Failed to parse response"
- Verify API response format
- Check model `fromJson` methods
- Check backend response structure

---

**Remember**: No UI changes were made. All integration happens in:
- Controllers (business logic)
- Services (API communication)
- Models (data structure)
