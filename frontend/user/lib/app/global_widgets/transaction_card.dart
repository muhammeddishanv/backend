import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/student/history/history.view.dart'; // Import the Transaction model

// A custom widget for a single transaction card
class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Get.theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(transaction.icon,
                  color: Get.theme.colorScheme.primary,
                  size: 28), // Increased icon size
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column( // Wrapped in a Column to stack the ID text
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ID:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Get.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        transaction.transactionId,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    transaction.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: transaction.statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}