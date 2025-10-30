import '../models/notification_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Notification Service
/// Handles all notification-related API operations
class NotificationService {
  final ApiClient _apiClient = ApiClient();

  /// Get notifications (optionally filtered by user)
  Future<ApiResponse<List<NotificationModel>>> getNotifications({
    String? userId,
  }) async {
    String endpoint = userId != null
        ? ApiConfig.notificationsByUser(userId)
        : ApiConfig.notifications;

    final response = await _apiClient.get<List<NotificationModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => NotificationModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Create a new notification
  Future<ApiResponse<NotificationModel>> createNotification(
    NotificationModel notification,
  ) async {
    final response = await _apiClient.post<NotificationModel>(
      ApiConfig.notifications,
      body: notification.toJson(),
      fromJson: (data) => NotificationModel.fromJson(data),
    );

    return response;
  }

  /// Mark notification as read
  Future<ApiResponse<NotificationModel>> markAsRead(String id) async {
    final response = await _apiClient.put<NotificationModel>(
      ApiConfig.notificationById(id),
      fromJson: (data) => NotificationModel.fromJson(data),
    );

    return response;
  }
}
