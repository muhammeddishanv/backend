import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../global_widgets/transaction_card.dart';

// Data model for a transaction entry
class Transaction {
  final String type;
  final String amount;
  final String transactionId;
  final String date;
  final String status;
  final Color statusColor;
  final IconData icon;

  Transaction({
    required this.type,
    required this.amount,
    required this.transactionId,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}

// Dummy controller to satisfy GetResponsiveView's generic type
class HistoryController extends GetxController {}

class HistoryView extends GetResponsiveView<HistoryController> {
  HistoryView({super.key}) : super(alwaysUseBuilder: false);

  final List<Transaction> _transactions = [
    Transaction(
      type: 'Points exchange',
      amount: '350 pts',
      transactionId: '698094554317',
      date: '16 Sep 2023\n16:08 PM',
      status: 'confirm',
      statusColor: Colors.green,
      icon: Icons.refresh,
    ),
    Transaction(
      type: 'Coins earned',
      amount: '10 Coins',
      transactionId: '564925374920',
      date: '16 Sep 2023\n16:08 PM',
      status: 'earned',
      statusColor: Colors.blue,
      icon: Icons.monetization_on,
    ),
    Transaction(
      type: 'Coins spent',
      amount: '20 Coins',
      transactionId: '685746354219',
      date: '16 Sep 2023\n16:08 PM',
      status: 'spent',
      statusColor: Colors.red,
      icon: Icons.monetization_on,
    ),
    Transaction(
      type: 'Points earned',
      amount: '300 pts',
      transactionId: '698094554317',
      date: '16 Sep 2023\n16:08 PM',
      status: 'confirm',
      statusColor: Colors.green,
      icon: Icons.star,
    ),
  ];

  Widget? phone() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Get.theme.colorScheme.onPrimary,
        title: Text(
          'Points & Coins Transaction History',
          style: TextStyle(
            color: Get.theme.colorScheme.onPrimary,
            fontSize: 20,
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Get.back(),
        // ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildFilterChips().paddingOnly(bottom: 16),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          return TransactionCard(transaction: _transactions[index]);
        },
      ),
    );
  }

  @override
  Widget? tablet() {
    return phone(); // Reuse the phone layout for tablet
  }

  @override
  Widget? desktop() {
    return phone(); // Reuse the phone layout for desktop
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Selected "All"
          RawChip(
            avatar: const Icon(Icons.check, size: 18, color: Colors.black),
            label: const Text(
              'All',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide.none,
          ),
          const SizedBox(width: 8),

          // "Yesterday"
          RawChip(
            label: const Text(
              'Yesterday',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide.none,
          ),
          const SizedBox(width: 8),

          // "This Week"
          RawChip(
            label: const Text(
              'This Week',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide.none,
          ),
          const SizedBox(width: 8),

          // "This Month"
          RawChip(
            label: const Text(
              'This Month',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide.none,
          ),
        ],
      ),
    );
  }
}