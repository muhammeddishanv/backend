import '../models/transaction_model.dart';
import '../../config/api_config.dart';
import 'api_client.dart';

/// Transaction Service
/// Handles all transaction-related API operations
class TransactionService {
  final ApiClient _apiClient = ApiClient();

  /// Get transactions (optionally filtered by user)
  Future<ApiResponse<List<TransactionModel>>> getTransactions({
    String? userId,
  }) async {
    String endpoint = userId != null
        ? ApiConfig.transactionsByUser(userId)
        : ApiConfig.transactions;

    final response = await _apiClient.get<List<TransactionModel>>(
      endpoint,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TransactionModel.fromJson(item)).toList();
        }
        return [];
      },
    );

    return response;
  }

  /// Create a new transaction
  Future<ApiResponse<TransactionModel>> createTransaction(
    TransactionModel transaction,
  ) async {
    final response = await _apiClient.post<TransactionModel>(
      ApiConfig.transactions,
      body: transaction.toJson(),
      fromJson: (data) => TransactionModel.fromJson(data),
    );

    return response;
  }
}
