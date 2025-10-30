/// API Configuration
/// Contains all API endpoints and configuration settings
class ApiConfig {
  // Base URL for the backend API
  // Replace with your actual Appwrite Function URL
  static const String baseUrl =
      'https://68c2a1d90003e461b539.fra.appwrite.run/';

  // API version (if applicable)
  static const String apiVersion = 'v1';

  // Timeout duration for API requests
  static const Duration timeoutDuration = Duration(seconds: 30);

  // API Endpoints
  static const String health = '/health';

  // Course endpoints
  static const String courses = '/courses';
  static String courseById(String id) => '/courses/$id';

  // Lesson endpoints
  static const String lessons = '/lessons';
  static String lessonById(String id) => '/lessons/$id';
  static String lessonsByCourse(String courseId) =>
      '/lessons?courseId=$courseId';

  // Quiz endpoints
  static const String quizzes = '/quizzes';
  static String quizById(String id) => '/quizzes/$id';
  static String quizzesByCourse(String courseId) =>
      '/quizzes?courseId=$courseId';

  // Quiz Question endpoints
  static const String quizQuestions = '/quiz-questions';
  static String quizQuestionById(String id) => '/quiz-questions/$id';
  static String quizQuestionsByQuiz(String quizId) =>
      '/quiz-questions?quizId=$quizId';

  // User Progress endpoints
  static const String progress = '/progress';
  static String progressByUser(String userId) => '/progress?userId=$userId';
  static String progressByCourse(String userId, String courseId) =>
      '/progress?userId=$userId&courseId=$courseId';

  // Quiz Attempt endpoints
  static const String quizAttempts = '/quiz-attempts';
  static String quizAttemptsByUser(String userId) =>
      '/quiz-attempts?userId=$userId';
  static String quizAttemptsByQuiz(String userId, String quizId) =>
      '/quiz-attempts?userId=$userId&quizId=$quizId';

  // Transaction endpoints
  static const String transactions = '/transactions';
  static String transactionsByUser(String userId) =>
      '/transactions?userId=$userId';

  // Rank endpoints
  static const String ranks = '/ranks';
  static String ranksByCourse(String courseId) => '/ranks?courseId=$courseId';

  // Badge endpoints
  static const String badges = '/badges';
  static String badgeById(String id) => '/badges/$id';

  // User Badge endpoints
  static const String userBadges = '/user-badges';
  static String userBadgesByUser(String userId) =>
      '/user-badges?userId=$userId';

  // Notification endpoints
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static String notificationsByUser(String userId) =>
      '/notifications?userId=$userId';

  // File upload endpoint
  static const String upload = '/upload';
}
