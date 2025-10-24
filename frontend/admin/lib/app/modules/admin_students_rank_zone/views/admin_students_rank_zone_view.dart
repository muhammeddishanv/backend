// View for the Admin Students Rank Zone.
// This file defines responsive UI for the student ranking tables used in the admin dashboard.
// Keep visual helpers and sample data here; move data-fetch logic to the controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../routes/app_pages.dart';

class AdminStudentsRankZoneView extends GetResponsiveView {
  AdminStudentsRankZoneView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox();
  @override
  Widget tablet() => const SizedBox();

  @override
  Widget desktop() {
    final List<String> categories = [
      'Biology',
      'Physics',
      'Chemistry',
      'IT',
      'English',
      'History',
    ];
    final RxString selectedCategory = 'Select Subject'.obs;

    final RxList<Map<String, dynamic>> overallRanks = <Map<String, dynamic>>[
      {"rank": 1, "student": "MARYAM", "score": 95, "progress": 95},
      {"rank": 2, "student": "RIFLI", "score": 92, "progress": 92},
      {"rank": 3, "student": "HARRY", "score": 90, "progress": 90},
      {"rank": 4, "student": "ABBAS", "score": 87, "progress": 87},
      {"rank": 5, "student": "ASGHAR", "score": 85, "progress": 85},
      {"rank": 6, "student": "FARNADI", "score": 82, "progress": 82},
      {"rank": 7, "student": "SEJAL", "score": 81, "progress": 81},
      {"rank": 8, "student": "AIDEN", "score": 79, "progress": 79},
      {"rank": 9, "student": "DARCY", "score": 77, "progress": 77},
      {"rank": 10, "student": "ELIZBETH", "score": 75, "progress": 75},
    ].obs;

    final RxList<Map<String, dynamic>> subjectRanks = <Map<String, dynamic>>[
      {"rank": 1, "student": "JACK", "score": 88, "progress": 88},
      {"rank": 2, "student": "LISA", "score": 85, "progress": 85},
      {"rank": 3, "student": "TOM", "score": 83, "progress": 83},
      {"rank": 4, "student": "NINA", "score": 80, "progress": 80},
      {"rank": 5, "student": "SAM", "score": 78, "progress": 78},
      {"rank": 6, "student": "RITA", "score": 76, "progress": 76},
      {"rank": 7, "student": "VIKRAM", "score": 74, "progress": 74},
      {"rank": 8, "student": "JUNE", "score": 72, "progress": 72},
      {"rank": 9, "student": "OMAR", "score": 70, "progress": 70},
      {"rank": 10, "student": "PRIYA", "score": 68, "progress": 68},
    ].obs;

    Widget rankTable(BuildContext context, List<Map<String, dynamic>> data) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      "RANK",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "STUDENT",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "SCORE",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "PROGRESS",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            // Data Rows
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemCount: data.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final s = data[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            "${s["rank"]}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              s["student"],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            "${s["score"]}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 140,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: s["progress"] / 100,
                                    minHeight: 10,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  "${s["progress"]}%",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                  textAlign: TextAlign.end,
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
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.surface,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: 11,
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () => Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                  child: Builder(
                    builder: (context) => Text(
                      "Student Rank Zone",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (context) => TabBar(
                              labelColor: Theme.of(context).colorScheme.primary,
                              unselectedLabelColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                              indicatorColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              indicatorWeight: 3.0,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              unselectedLabelStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                              tabs: const [
                                Tab(text: "Overall"),
                                Tab(text: "Subject"),
                              ],
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Builder(
                              builder: (context) => TabBarView(
                                children: [
                                  // Overall Tab - No dropdown
                                  Obx(() => rankTable(context, overallRanks)),
                                  // Subject Tab - With dropdown
                                  Column(
                                    children: [
                                      // Dropdown for subject selection
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            SizedBox(
                                              width: 200,
                                              child: DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Theme.of(
                                                    context,
                                                  ).colorScheme.surfaceVariant,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                hint: Text(
                                                  "Select Subject",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                items: categories
                                                    .map(
                                                      (String value) =>
                                                          DropdownMenuItem<
                                                            String
                                                          >(
                                                            value: value,
                                                            child: Text(value),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    selectedCategory.value =
                                                        newValue;
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Subject rank table
                                      Expanded(
                                        child: Obx(
                                          () =>
                                              rankTable(context, subjectRanks),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
