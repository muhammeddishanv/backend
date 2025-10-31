// View: Admin User Details
// Purpose: Detailed view for a single user's profile, chapters, and unlock controls.
// The controller should supply the user data; this file renders and formats it.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_user_details_controller.dart';
import '../../../global_widgets/nav_bar.dart'; // Assuming this is the AdminSidebar
import '../../../routes/app_pages.dart';

// Contextual Variables from the prompt, included here for completeness:
final RxList<Map<String, String>> students = <Map<String, String>>[
  {"name": "Sophia Bent", "role": "Student"},
  {"name": "Liam Harper", "role": "Student"},
  {"name": "Olivia Reed", "role": "Student"},
  {"name": "Noah Foster", "role": "Student"},
  {"name": "Ava Morgan", "role": "Student"},
  {"name": "Sophia Bent", "role": "Student"},
  {"name": "Olivia Reed", "role": "Student"},
  {"name": "Marcus Stone", "role": "Student"},
  {"name": "Evelyn Ross", "role": "Student"},
  {"name": "Owen King", "role": "Student"},
].obs;

// Helper function from the prompt:
Widget _buildCard(BuildContext context, {required Widget child}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    decoration: BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      // 💡 REPLACED: Removed boxShadow.
      // ✅ ADDED: A solid border using colorScheme.outline.
      border: Border.all(
        color: colorScheme.outline,
        width: 1.0, // Standard border thickness
      ),
    ),
    padding: const EdgeInsets.all(12),
    child: child,
  );
}

// Custom ScrollBehavior to hide the scrollbar
class NoBarScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Return the child directly, effectively hiding the scrollbar
    return child;
  }
}

class AdminUserDetailsView
    extends GetResponsiveView<AdminUserDetailsController> {
  AdminUserDetailsView({super.key}) : super(alwaysUseBuilder: false);

  // Observable variable to track the selected student's index.
  final RxInt _selectedStudentIndex = (-1).obs;

  @override
  Widget phone() => const SizedBox.shrink(); // not needed

  @override
  Widget tablet() => const SizedBox.shrink(); // not needed

  // Table row (MODIFIED: Added Align for chapter text for alignment fix)
  DataRow _buildRow(BuildContext context, String chapter, bool isUnlocked) {
    final colorScheme = Theme.of(context).colorScheme;
    RxBool switchState = isUnlocked.obs;

    return DataRow(
      cells: [
        // 💡 ALIGNMENT FIX: Wrap Text in an Align widget for consistent left alignment
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(chapter, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ),
        // Switch control is naturally centered within its column
        DataCell(
          Obx(
            () => Transform.scale(
              scale: 0.8,
              child: Switch(
                value: switchState.value,
                activeColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.surfaceVariant,
                onChanged: (newValue) {
                  switchState.value = newValue;
                  print(
                    "Chapter: $chapter, New State: ${newValue ? 'UNLOCKED' : 'LOCKED'}",
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Local function for the Students List (RETAINED)
  Widget _buildStudentsList(ColorScheme colorScheme) {
    final Color defaultBorderColor = colorScheme.outlineVariant;
    final Color hoverBorderColor = colorScheme.primary;
    final Color selectedBgColor = colorScheme.primaryContainer;
    final Color selectedBorderColor = colorScheme.primary;

    return Expanded(
      flex: 2, // Retains a smaller flex factor for the list
      child: _buildCard(
        Get.context!,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Students List",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ScrollConfiguration(
                  // Use custom ScrollBehavior to hide the scrollbar
                  behavior: NoBarScrollBehavior(),
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: students.length,
                    itemBuilder: (context, i) {
                      final st = students[i];
                      final RxBool isHovered = false.obs;
                      final bool isSelected = _selectedStudentIndex.value == i;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Obx(
                          () => MouseRegion(
                            onEnter: (_) => isHovered.value = true,
                            onExit: (_) => isHovered.value = false,
                            child: GestureDetector(
                              onTap: () {
                                _selectedStudentIndex.value = i;
                                print(
                                  "Tapped on ${st["name"]}. Selected Index: $i",
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? selectedBgColor
                                      : isHovered.value
                                      ? colorScheme.primaryContainer
                                            .withOpacity(0.3)
                                      : colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? selectedBorderColor
                                        : isHovered.value
                                        ? hoverBorderColor
                                        : defaultBorderColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected || isHovered.value
                                      ? [
                                          BoxShadow(
                                            color: colorScheme.primary
                                                .withOpacity(
                                                  isSelected ? 0.2 : 0.1,
                                                ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: colorScheme.shadow
                                                .withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.primaryContainer,
                                    child: Text(
                                      st["name"]![0],
                                      style: TextStyle(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    st["name"] ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                  subtitle: Text(
                                    st["role"] ?? "",
                                    style: TextStyle(
                                      color: isSelected
                                          ? colorScheme.primary.withOpacity(0.8)
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          color: colorScheme.primary,
                                          size: 20,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget desktop() {
    final colorScheme = Theme.of(Get.context!).colorScheme;
    final textTheme = Theme.of(Get.context!).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        children: [
          // AdminSidebar widget
          AdminSidebar(
            selectedIndex: 2,
            onMenuSelected: _navigateToPage,
            onLogout: () {
              Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN);
            },
          ),

          // Main Content
          Expanded(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.all(
                      constraints.maxWidth > 1200 ? 32 : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Unlock Content",
                              style: textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onBackground,
                              ),
                            ),
                            // Subject dropdown with padding
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: SizedBox(
                                width: 200,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: colorScheme.surfaceVariant,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  hint: Text(
                                    "Select Subject", // <-- This is the hint text you see
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withOpacity(
                                        0.6,
                                      ),
                                    ),
                                  ),
                                  items: List.generate(5, (index) {
                                    return DropdownMenuItem<String>(
                                      value: "Subject ${index + 1}",
                                      child: Text("Subject ${index + 1}"),
                                    );
                                  }),
                                  onChanged: (value) {
                                    print("Selected: $value");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Row for Students List and Content Table
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Students List (LEFT)
                              _buildStudentsList(colorScheme),

                              const SizedBox(width: 20), // Spacer
                              // 2. Existing Flexible Table (RIGHT)
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                  // Removed nested horizontal scroll/constraints so table stretches fully
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: colorScheme.outlineVariant,
                                    ),
                                    child: LayoutBuilder(
                                      builder: (context, boxConstraints) {
                                        return SingleChildScrollView(
                                          // keep vertical scroll only if content larger than height
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: boxConstraints.maxWidth,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: DataTable(
                                                columnSpacing: 24,
                                                horizontalMargin:
                                                    0, // keep cells tight within padded area
                                                headingRowHeight: 48,
                                                dataRowHeight: 56,
                                                headingTextStyle: textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                                columns: const [
                                                  DataColumn(
                                                    label: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text("Chapter"),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text("Actions"),
                                                    ),
                                                    numeric: true,
                                                  ),
                                                ],
                                                rows: [
                                                  _buildRow(
                                                    context,
                                                    "Introduction to Programming",
                                                    true,
                                                  ),
                                                  _buildRow(
                                                    context,
                                                    "Data Structures and Algorithms",
                                                    true,
                                                  ),
                                                  _buildRow(
                                                    context,
                                                    "Web Development Fundamentals",
                                                    true,
                                                  ),
                                                  _buildRow(
                                                    context,
                                                    "Machine Learning Basics",
                                                    false,
                                                  ),
                                                  _buildRow(
                                                    context,
                                                    "Advanced Topics in AI",
                                                    false,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
        Get.toNamed(Routes.ADMIN_LESSON_MANAGEMENT);
        break;
      case 7:
        // TODO: Implement edit lesson functionality
        break;
      case 8:
        Get.toNamed(Routes.QUIZ_MANAGEMENT);
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
