# EdTech Platform - Frontend-Backend Integration

This document explains the architecture and integration between the backend API and frontend applications (Admin & User).

## Architecture Overview

### Backend Structure
- **Platform**: Appwrite Functions (Node.js)
- **API Type**: RESTful API
- **Base Endpoint**: To be configured in frontend config files

### Frontend Structure
Both Admin and User apps follow the same architectural pattern:

```
lib/
├── app/
│   ├── config/
│   │   └── api_config.dart          # API endpoints configuration
│   ├── data/
│   │   ├── models/                  # Data models (Course, Lesson, Quiz, etc.)
│   │   ├── services/                # API service layer
│   │   │   ├── api_client.dart      # HTTP client wrapper
│   │   │   ├── course_service.dart  # Course CRUD operations
│   │   │   ├── lesson_service.dart  # Lesson CRUD operations
│   │   │   └── ...                  # Other service files
│   │   └── controllers/             # Business logic controllers
│   ├── modules/                     # Feature modules
│   └── routes/                      # Navigation routes
└── main.dart
```

## Data Models

All data models are located in `lib/app/data/models/` and include:

### Core Models
1. **CourseModel** - Course/Subject information
2. **LessonModel** - Lesson content and metadata
3. **QuizModel** - Quiz configuration
4. **QuizQuestionModel** - Quiz questions and answers
5. **UserProgressModel** - User learning progress
6. **QuizAttemptModel** - Quiz attempt records
7. **TransactionModel** - Payment transactions
8. **RankModel** - User rankings
9. **BadgeModel** - Achievement badges
10. **UserBadgeModel** - User-earned badges
11. **NotificationModel** - User notifications

### Model Features
- JSON serialization/deserialization
- Immutable with `copyWith()` methods
- Null-safe properties
- Support for Appwrite's `$id`, `$createdAt`, `$updatedAt` fields

## API Services

### API Client (`api_client.dart`)
Central HTTP client that handles:
- GET requests
- POST requests
- PUT requests
- PATCH requests
- DELETE requests
- Error handling
- Response parsing
- Timeout management

#### Usage Example:
```dart
final apiClient = ApiClient();

// GET request
final response = await apiClient.get<CourseModel>(
  '/courses/123',
  fromJson: (data) => CourseModel.fromJson(data),
);

// POST request
final response = await apiClient.post<CourseModel>(
  '/courses',
  body: courseData,
  fromJson: (data) => CourseModel.fromJson(data),
);
```

### Service Layer
Each entity has its own service class:

#### CourseService
```dart
final courseService = CourseService();

// Get all courses
await courseService.getAllCourses();

// Get course by ID
await courseService.getCourseById('course_123');

// Create course
await courseService.createCourse(courseModel);

// Update course
await courseService.updateCourse('course_123', courseModel);

// Delete course
await courseService.deleteCourse('course_123');
```

#### LessonService
- `getAllLessons({courseId})` - Get lessons, optionally filtered by course
- `getLessonById(id)` - Get specific lesson
- `createLesson(lesson)` - Create new lesson
- `updateLesson(id, lesson)` - Update lesson
- `deleteLesson(id)` - Delete lesson

#### QuizService
- `getAllQuizzes({courseId})` - Get quizzes
- `getQuizById(id)` - Get specific quiz
- `createQuiz(quiz)` - Create quiz
- `updateQuiz(id, quiz)` - Update quiz
- `deleteQuiz(id)` - Delete quiz

#### UserProgressService
- `getUserProgress({userId, courseId})` - Get user progress
- `saveProgress(progress)` - Create or update progress

#### QuizAttemptService
- `getQuizAttempts({userId, quizId})` - Get quiz attempts
- `submitQuizAttempt(attempt)` - Submit quiz attempt

#### NotificationService
- `getNotifications({userId})` - Get notifications
- `createNotification(notification)` - Create notification
- `markAsRead(id)` - Mark notification as read

## Configuration

### Step 1: Update API Base URL

**Location**: `lib/app/config/api_config.dart`

Replace the placeholder with your actual Appwrite Function URL:

```dart
class ApiConfig {
  // Replace this with your actual Appwrite Function URL
  static const String baseUrl = 'YOUR_APPWRITE_FUNCTION_URL';
  // Example: 'https://cloud.appwrite.io/v1/functions/your-function-id/executions'
}
```

### Step 2: Install Dependencies

Run in both admin and user app directories:

```bash
flutter pub get
```

This will install the `http` package that was added to `pubspec.yaml`.

## Controller Integration

### Example: Admin Subject Management Controller

```dart
class AdminSubjectManagementController extends GetxController {
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
    }
    
    isLoading.value = false;
  }

  Future<bool> createCourse(CourseModel course) async {
    final response = await _courseService.createCourse(course);
    
    if (response.success && response.data != null) {
      courses.add(response.data!);
      return true;
    }
    
    return false;
  }
}
```

### Example: User Dashboard Controller

```dart
class DashboardController extends GetxController {
  final CourseService _courseService = CourseService();
  final UserProgressService _progressService = UserProgressService();
  
  final RxList<CourseModel> enrolledCourses = <CourseModel>[].obs;
  final RxList<UserProgressModel> userProgress = <UserProgressModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    await loadEnrolledCourses();
    await loadUserProgress();
  }

  Future<void> loadEnrolledCourses() async {
    final response = await _courseService.getAllCourses();
    if (response.success && response.data != null) {
      enrolledCourses.value = response.data!;
    }
  }
}
```

## API Endpoints

All available endpoints are defined in `api_config.dart`:

### Courses
- `GET /courses` - List all courses
- `GET /courses/:id` - Get course by ID
- `POST /courses` - Create course
- `PUT /courses/:id` - Update course
- `DELETE /courses/:id` - Delete course

### Lessons
- `GET /lessons` - List all lessons
- `GET /lessons/:id` - Get lesson by ID
- `GET /lessons?courseId=:id` - Get lessons by course
- `POST /lessons` - Create lesson
- `PUT /lessons/:id` - Update lesson
- `DELETE /lessons/:id` - Delete lesson

### Quizzes
- `GET /quizzes` - List all quizzes
- `GET /quizzes/:id` - Get quiz by ID
- `GET /quizzes?courseId=:id` - Get quizzes by course
- `POST /quizzes` - Create quiz
- `PUT /quizzes/:id` - Update quiz
- `DELETE /quizzes/:id` - Delete quiz

### Quiz Questions
- `GET /quiz-questions?quizId=:id` - Get questions by quiz
- `POST /quiz-questions` - Create question
- `PUT /quiz-questions/:id` - Update question
- `DELETE /quiz-questions/:id` - Delete question

### User Progress
- `GET /progress?userId=:id` - Get user progress
- `GET /progress?userId=:id&courseId=:id` - Get progress by course
- `POST /progress` - Save progress

### Quiz Attempts
- `GET /quiz-attempts?userId=:id` - Get user quiz attempts
- `POST /quiz-attempts` - Submit quiz attempt

### Notifications
- `GET /notifications?userId=:id` - Get user notifications
- `POST /notifications` - Create notification
- `PUT /notifications/:id` - Mark as read

## Error Handling

All API responses follow this structure:

```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? message;
}
```

### Handling Errors in Controllers

```dart
Future<void> loadData() async {
  try {
    final response = await _service.getData();
    
    if (response.success && response.data != null) {
      // Success - update UI
      data.value = response.data!;
    } else {
      // API returned error
      Get.snackbar('Error', response.error ?? 'Failed to load data');
    }
  } catch (e) {
    // Network or parsing error
    Get.snackbar('Error', 'An error occurred: $e');
  }
}
```

## Best Practices

### 1. Controller Usage
- Keep controllers focused on business logic
- Use services for all API calls
- Implement loading states
- Handle errors appropriately
- Show user feedback (snackbars, dialogs)

### 2. Service Usage
- Always use the service layer for API calls
- Don't make direct HTTP calls from controllers
- Return typed `ApiResponse` objects
- Include proper error handling

### 3. Model Usage
- Always use `toJson()` when sending data to API
- Always use `fromJson()` when receiving data from API
- Use `copyWith()` for updating model instances
- Keep models immutable

### 4. State Management
- Use `.obs` for reactive variables
- Update observable values to trigger UI updates
- Use `Obx()` or `GetX<>` widgets in views

## Next Steps

### For Admin App:
1. Update all module controllers to use the new services
2. Implement create/edit forms that use the models
3. Add proper error handling and loading states
4. Test all CRUD operations

### For User App:
1. Integrate course browsing with CourseService
2. Implement lesson viewing with LessonService
3. Add quiz functionality with QuizService
4. Track progress with UserProgressService
5. Display notifications with NotificationService

## Testing

### Test API Connection:
1. Update `baseUrl` in `api_config.dart`
2. Run the app
3. Check debug console for API responses
4. Verify data loads correctly

### Common Issues:
- **Connection Error**: Check if `baseUrl` is correct
- **Parsing Error**: Verify model `fromJson` methods match API response
- **Timeout**: Increase `timeoutDuration` in `api_config.dart`
- **CORS Error**: Ensure backend has proper CORS headers (already configured)

## Support

For questions or issues:
1. Check backend API documentation
2. Review model definitions
3. Test with Postman/API client first
4. Check console logs for detailed errors

---

**Note**: This architecture maintains separation of concerns:
- **Models**: Data structure only
- **Services**: API communication
- **Controllers**: Business logic and state management
- **Views**: UI rendering

All changes were made without modifying UI code, as requested.
