// View: Admin Transaction History
// Purpose: Display transactions, payments and reward activities. Keep data fetching in controllers/services.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../routes/app_pages.dart';

class AdminTransactionHistoryView extends GetResponsiveView {
  AdminTransactionHistoryView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox(); // not needed
  @override
  Widget tablet() => const SizedBox(); // not needed

  @override
  Widget desktop() {
    /// Selected student tracking
    final RxString selectedStudentName = ''.obs;

    /// Dummy Students List
    final RxList<Map<String, String>> students = <Map<String, String>>[
      {"name": "Mariyam", "role": "Student"},
      {"name": "Liam Harper", "role": "Student"},
      {"name": "Olivia Reed", "role": "Student"},
      {"name": "Noah Foster", "role": "Student"},
      {"name": "Ava Morgan", "role": "Student"},
      {"name": "Sophia Bent", "role": "Student"},
      {"name": "Olivia Reed", "role": "Student"},
      {"name": "Liam Harper", "role": "Student"},
    ].obs;

    /// Dummy Payment Transactions
    final RxList<Map<String, dynamic>> payments = <Map<String, dynamic>>[
      {
        "name": "Tomas",
        "amount": "₹ 350.00",
        "status": "pending",
        "date": "17 Sep 2023 11:21 AM",
        "id": "698094554317",
      },
      {
        "name": "Serrena",
        "amount": "₹ 100.00",
        "status": "confirmed",
        "date": "17 Sep 2023 10:34 AM",
        "id": "564925374920",
      },
      {
        "name": "Jacob",
        "amount": "₹ 1.75",
        "status": "confirmed",
        "date": "16 Sep 2023 16:08 PM",
        "id": "685746354219",
      },
      {
        "name": "Rinees",
        "amount": "₹ 9000.00",
        "status": "confirmed",
        "date": "16 Sep 2023 11:21 AM",
        "id": "698094554317",
      },
      {
        "name": "Nayana",
        "amount": "₹ 9267.00",
        "status": "cancelled",
        "date": "15 Sep 2023 10:11 AM",
        "id": "097967542786",
      },
      {
        "name": "Mariyam",
        "amount": "₹ 3.21",
        "status": "confirmed",
        "date": "14 Sep 2023 18:59 PM",
        "id": "765230978421",
      },
    ].obs;

    /// Dummy Coins and Points Transactions
    final RxList<Map<String, dynamic>> rewards = <Map<String, dynamic>>[
      {
        "type": "Points exchange",
        "value": "350 pts",
        "status": "confirmed",
        "date": "16 Sep 2023 16:08 PM",
        "id": "698094554317",
      },
      {
        "type": "Coins earned",
        "value": "10 Coins",
        "status": "earned",
        "date": "16 Sep 2023 16:08 PM",
        "id": "564925374920",
      },
      {
        "type": "Coins spent",
        "value": "20 Coins",
        "status": "spent",
        "date": "16 Sep 2023 16:08 PM",
        "id": "685746354219",
      },
      {
        "type": "Points earned",
        "value": "300 pts",
        "status": "confirmed",
        "date": "16 Sep 2023 16:08 PM",
        "id": "698094554317",
      },
    ].obs;

    /// Helper widget for card
    Widget buildCard(BuildContext context, {required Widget child}) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: child,
      );
    }

    /// Chip Filter Row
    Widget buildFilters() {
      final filters = ["All", "Yesterday", "This Week", "This Month"];
      final RxString selected = "All".obs;
      return Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: filters.map((f) {
            final isSelected = selected.value == f;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(f),
                selected: isSelected,
                onSelected: (_) => selected.value = f,
                selectedColor: Theme.of(Get.context!).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(Get.context!).colorScheme.onPrimary
                      : Theme.of(Get.context!).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: isSelected
                    ? Theme.of(
                        Get.context!,
                      ).colorScheme.primary.withOpacity(0.8)
                    : Theme.of(
                        Get.context!,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(Get.context!).colorScheme.primary
                        : Theme.of(
                            Get.context!,
                          ).colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    /// Status Color & Text
    Color statusColor0(BuildContext context, String status) {
      switch (status) {
        case "confirmed":
        case "earned":
          return Theme.of(context).colorScheme.primary;
        case "pending":
          return Theme.of(context).colorScheme.secondary;
        case "cancelled":
        case "spent":
          return Theme.of(context).colorScheme.error;
        default:
          return Theme.of(context).colorScheme.onSurface;
      }
    }

    String getStatusText(String status) {
      return status.substring(0, 1).toUpperCase() + status.substring(1);
    }

    /// Custom List Item for Payments and Rewards
    Widget buildTransactionItem({
      required String title,
      required String transactionId,
      required String date,
      required String value,
      required String status,
      required Widget leading,
    }) {
      final BuildContext context = Get.context!; // Using GetX context
      final Color statusColor = statusColor0(context, status);

      // Split the date and time for separate display
      final dateParts = date.split(' ');
      final displayDate = '${dateParts[0]} ${dateParts[1]} ${dateParts[2]}';
      final displayTime = dateParts.length > 3
          ? '${dateParts[3]} ${dateParts[4]}'
          : '';

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transaction ID",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        transactionId,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getStatusText(status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  displayDate,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  displayTime,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Custom Student List Item
    Widget buildStudentListItem(Map<String, String> student) {
      return Obx(() {
        final isSelected = selectedStudentName.value == student["name"];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: Theme.of(Get.context!).colorScheme.surface.withOpacity(0.0),
            child: InkWell(
              onTap: () {
                // Handle student selection
                selectedStudentName.value = student["name"]!;
                print("Selected student: ${student["name"]}");
                // You can add navigation or other actions here
              },
              borderRadius: BorderRadius.circular(15),
              hoverColor: Theme.of(
                Get.context!,
              ).colorScheme.primary.withOpacity(0.15),
              splashColor: Theme.of(
                Get.context!,
              ).colorScheme.primary.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(
                          Get.context!,
                        ).colorScheme.primary.withOpacity(0.1)
                      : Theme.of(Get.context!).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(Get.context!).colorScheme.primary
                        : Theme.of(
                            Get.context!,
                          ).colorScheme.outline.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        Get.context!,
                      ).shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Replaced Image.asset with CircleAvatar
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: isSelected
                          ? Theme.of(Get.context!).colorScheme.primary
                          : Theme.of(
                              Get.context!,
                            ).colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        student["name"]![0],
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(Get.context!).colorScheme.onPrimary
                              : Theme.of(Get.context!).colorScheme.primary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student["name"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected
                                ? Theme.of(Get.context!).colorScheme.primary
                                : null,
                          ),
                        ),
                        Text(
                          student["role"]!,
                          style: TextStyle(
                            color: Theme.of(
                              Get.context!,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.surface,
      body: Row(
        children: [
          /// Sidebar
          AdminSidebar(
            selectedIndex: 9,
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () => Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN),
          ),

          /// Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transaction History",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(
                                  Get.context!,
                                ).colorScheme.surfaceVariant,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: Text(
                                "Select Subject",
                                style: TextStyle(
                                  color: Theme.of(
                                    Get.context!,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              items: List.generate(5, (index) {
                                return DropdownMenuItem<String>(
                                  value: "Subject ${index + 1}",
                                  child: Text("Subject ${index + 1}"),
                                );
                              }),
                              onChanged: (value) {
                                // Handle subject selection
                                print("Selected: $value");
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  /// Filters
                  buildFilters(),
                  const SizedBox(height: 32),

                  /// Three Sections
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Students List
                        Expanded(
                          flex: 2,
                          child: buildCard(
                            Get.context!,
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Students List",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(right: 16),
                                      itemCount: students.length,
                                      itemBuilder: (context, i) {
                                        final st = students[i];
                                        return buildStudentListItem(st);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        /// Payment Transactions
                        Expanded(
                          flex: 3,
                          child: buildCard(
                            Get.context!,
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Payment Transactions",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(right: 16),
                                      itemCount: payments.length,
                                      itemBuilder: (context, i) {
                                        final p = payments[i];
                                        return buildTransactionItem(
                                          leading: Builder(
                                            builder: (context) => CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.1),
                                              radius: 25,
                                              child: Text(
                                                p["name"]![0],
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: p["name"],
                                          transactionId: p["id"],
                                          date: p["date"],
                                          value: p["amount"],
                                          status: p["status"],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        /// Coins & Points Transactions
                        Expanded(
                          flex: 3,
                          child: buildCard(
                            Get.context!,
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Coins and Points Transaction",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(right: 16),
                                      itemCount: rewards.length,
                                      itemBuilder: (context, i) {
                                        final r = rewards[i];

                                        // Choose icon based on transaction type
                                        IconData iconData;
                                        switch (r["type"]) {
                                          case "Points exchange":
                                            iconData =
                                                Icons.swap_horizontal_circle;
                                            break;
                                          case "Coins earned":
                                            iconData = Icons.monetization_on;
                                            break;
                                          case "Coins spent":
                                            iconData = Icons.monetization_on;
                                            break;
                                          case "Points earned":
                                            iconData = Icons.star_outline;
                                            break;
                                          default:
                                            iconData = Icons.currency_bitcoin;
                                        }

                                        return buildTransactionItem(
                                          leading: Builder(
                                            builder: (context) => Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                iconData,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          title: r["type"],
                                          transactionId: r["id"],
                                          date: r["date"],
                                          value: r["value"],
                                          status: r["status"],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.ADMIN_DASHBOARD);
        break;
      case 1:
        Get.toNamed(Routes.ADMIN_USER_MANAGEMENT);
        break;
      case 2:
        Get.toNamed(Routes.ADMIN_USER_DETAILS);
        break;
      case 3:
        Get.toNamed(Routes.ADMIN_SUBJECT_MANAGEMENT);
        break;
      case 6:
        Get.toNamed(Routes.ADMIN_CREATE_LESSON);
        break;
      case 7:
        Get.toNamed(Routes.ADMIN_EDIT_LESSON);
        break;
      case 8:
        Get.toNamed(Routes.ADMIN_CREATE_QUIZ);
        break;
      case 9:
        Get.toNamed(Routes.ADMIN_TRANSACTION_HISTORY);
        break;
      case 10:
        Get.toNamed(Routes.ADMIN_PERFORMANCE_ANALYSIS);
        break;
      case 11:
        Get.toNamed(Routes.ADMIN_STUDENTS_RANK_ZONE);
        break;
    }
  }
}
