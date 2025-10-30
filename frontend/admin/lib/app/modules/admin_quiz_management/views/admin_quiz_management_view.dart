// View: Admin Quiz Management
// Purpose: UI for listing and managing quizzes under subjects/chapters in the admin panel.
// Keep heavy data logic in the controller; this file focuses only on widgets/layout.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../global_widgets/search_bar.dart';
import '../../../routes/app_pages.dart';


class AdminQuizManagementView extends GetResponsiveView {
  AdminQuizManagementView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox(); // not needed
  @override
  Widget tablet() => const SizedBox(); // not needed

  @override
  Widget desktop() {
    /// Quiz list — example static data.
    final RxList<Map<String, String>> quizzes = <Map<String, String>>[
      {
        "title": "Quiz on Motion (UVA)",
        "desc": "Covers concepts of displacement, velocity, and acceleration.",
        "category": "UVA",
      },
      {
        "title": "Quiz on Forces (PHY)",
        "desc": "Test your understanding of Newton’s Laws of Motion.",
        "category": "PHY",
      },
      {
        "title": "Quiz on Energy (PHY)",
        "desc": "Includes potential and kinetic energy questions.",
        "category": "PHY",
      },
    ].obs;

    /// Track edit state
    final RxSet<int> editingQuizzes = <int>{}.obs;

    /// ---------------- WIDGET HELPERS ----------------
    Widget _buildCard(BuildContext context, {required Widget child}) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: child,
      );
    }

    Widget _buildSearchRowWithDropdowns(
      BuildContext context, {
      required String searchHint,
      required String addLabel,
      required VoidCallback onAdd,
    }) {
      return Row(
        children: [
          Flexible(
            flex: 3,
            child: AdminSearchBar(onChanged: (value) {}, hintText: searchHint),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 2,
            child: DropdownButtonFormField<String>(
              menuMaxHeight: 200,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text("select category"),
              items: const [
                DropdownMenuItem(value: "UVA", child: Text("UVA")),
                DropdownMenuItem(value: "PHY", child: Text("PHY")),
              ],
              onChanged: (value) {},
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  addLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      );
    }

    /// ---------------- QUIZ ROW ----------------
    DataRow _buildRow(BuildContext context, int index) {
      final quiz = quizzes[index];
      final isEditing = editingQuizzes.contains(index);

      return DataRow(
        onSelectChanged: (selected) {
          print("Tapped on quiz row: ${quiz["title"]}");
        },
        cells: [
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: quiz["title"],
                    onChanged: (val) => quiz["title"] = val,
                  )
                : Text(quiz["title"] ?? ""),
          ),
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: quiz["desc"],
                    onChanged: (val) => quiz["desc"] = val,
                  )
                : Text(quiz["desc"] ?? ""),
          ),
          DataCell(
            Text(quiz["category"] ?? ""),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (isEditing) {
                      editingQuizzes.remove(index);
                    } else {
                      editingQuizzes.add(index);
                    }
                  },
                  icon: Icon(
                    isEditing ? Icons.save : Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Delete action (if needed)
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      );
    }

    /// ---------------- MAIN UI ----------------
    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: 12, // Ensure index 12 for Quiz Management
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () => Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN),
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Theme.of(Get.context!).colorScheme.background,
              body: Padding(
                padding: const EdgeInsets.all(32.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quiz Management",
                        style: Theme.of(Get.context!).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(Get.context!)
                                  .colorScheme
                                  .onBackground,
                            ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Quiz List",
                        style: Theme.of(Get.context!).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      _buildSearchRowWithDropdowns(
                        Get.context!,
                        searchHint: "search quizzes",
                        addLabel: "Add Quiz",
                        onAdd: () {
                          quizzes.add({
                            "title": "New Quiz Title",
                            "desc": "Quiz Description",
                            "category": "UVA",
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildCard(
                        Get.context!,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final col1 = constraints.maxWidth * 0.3;
                            final col2 = constraints.maxWidth * 0.4;
                            final col3 = constraints.maxWidth * 0.15;
                            final col4 = constraints.maxWidth * 0.15;

                            return Obx(
                              () => DataTable(
                                showCheckboxColumn: false,
                                headingRowHeight: 45,
                                dataRowHeight: 55,
                                headingTextStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: col1,
                                      child: const Text("Quiz Title"),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: col2,
                                      child: const Text("Description"),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: col3,
                                      child: const Text("Category"),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: col4,
                                      child: const Text("Actions"),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  quizzes.length,
                                  (i) => _buildRow(Get.context!, i),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
      case 12:
        Get.toNamed(Routes.ADMIN_QUIZ_MANAGEMENT);
        break;
    }
  }
}