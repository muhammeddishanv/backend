import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../routes/app_pages.dart';

class AdminPerformanceAnalysisView extends GetResponsiveView {
  AdminPerformanceAnalysisView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox();
  @override
  Widget tablet() => const SizedBox();

  @override
  Widget desktop() {
    /// Selected student tracking
    final RxString selectedStudentName = ''.obs;

    final RxList<Map<String, String>> students = <Map<String, String>>[
      {"name": "Sophia Bent", "role": "Student"},
      {"name": "Liam Harper", "role": "Student"},
      {"name": "Olivia Reed", "role": "Student"},
      {"name": "Noah Foster", "role": "Student"},
      {"name": "Ava Morgan", "role": "Student"},
      {"name": "Sophia ", "role": "Student"},
      {"name": "Olivia ", "role": "Student"},
    ].obs;

    // Student-specific data
    final Map<String, List<Map<String, dynamic>>> studentCoursesData = {
      "Sophia Bent": [
        {"name": "Biology", "progress": 95, "icon": Icons.science},
        {"name": "Physics", "progress": 88, "icon": Icons.bubble_chart},
        {"name": "Chemistry", "progress": 92, "icon": Icons.biotech},
        {"name": "IT", "progress": 85, "icon": Icons.computer},
        {"name": "English", "progress": 90, "icon": Icons.menu_book},
        {"name": "History", "progress": 87, "icon": Icons.book},
      ],
      "Liam Harper": [
        {"name": "Biology", "progress": 78, "icon": Icons.science},
        {"name": "Physics", "progress": 82, "icon": Icons.bubble_chart},
        {"name": "Chemistry", "progress": 75, "icon": Icons.biotech},
        {"name": "IT", "progress": 90, "icon": Icons.computer},
        {"name": "English", "progress": 85, "icon": Icons.menu_book},
        {"name": "History", "progress": 80, "icon": Icons.book},
      ],
      "Olivia Reed": [
        {"name": "Biology", "progress": 88, "icon": Icons.science},
        {"name": "Physics", "progress": 70, "icon": Icons.bubble_chart},
        {"name": "Chemistry", "progress": 85, "icon": Icons.biotech},
        {"name": "IT", "progress": 92, "icon": Icons.computer},
        {"name": "English", "progress": 88, "icon": Icons.menu_book},
        {"name": "History", "progress": 83, "icon": Icons.book},
      ],
      "Noah Foster": [
        {"name": "Biology", "progress": 72, "icon": Icons.science},
        {"name": "Physics", "progress": 85, "icon": Icons.bubble_chart},
        {"name": "Chemistry", "progress": 78, "icon": Icons.biotech},
        {"name": "IT", "progress": 88, "icon": Icons.computer},
        {"name": "English", "progress": 75, "icon": Icons.menu_book},
        {"name": "History", "progress": 80, "icon": Icons.book},
      ],
      "Ava Morgan": [
        {"name": "Biology", "progress": 90, "icon": Icons.science},
        {"name": "Physics", "progress": 88, "icon": Icons.bubble_chart},
        {"name": "Chemistry", "progress": 85, "icon": Icons.biotech},
        {"name": "IT", "progress": 78, "icon": Icons.computer},
        {"name": "English", "progress": 92, "icon": Icons.menu_book},
        {"name": "History", "progress": 87, "icon": Icons.book},
      ],
    };

    final Map<String, Map<String, dynamic>> studentProgressData = {
      "Sophia Bent": {"ranking": 1, "total": 300, "status": "Excellent"},
      "Liam Harper": {"ranking": 15, "total": 300, "status": "Good"},
      "Olivia Reed": {"ranking": 8, "total": 300, "status": "Very Good"},
      "Noah Foster": {"ranking": 25, "total": 300, "status": "Average"},
      "Ava Morgan": {"ranking": 5, "total": 300, "status": "Excellent"},
    };

    final Map<String, List<Map<String, dynamic>>> studentPerformanceData = {
      "Sophia Bent": [
        {"label": "Test Taken", "value": 28, "icon": Icons.assignment},
        {"label": "Avg Test Score", "value": 92, "icon": Icons.star},
        {
          "label": "Highest Test Score",
          "value": 98,
          "icon": Icons.emoji_events,
        },
        {"label": "Course Completed", "value": 6, "icon": Icons.school},
        {"label": "Avg Watch Time", "value": 85, "icon": Icons.access_time},
        {"label": "Chapters Completed", "value": 45, "icon": Icons.menu_book},
      ],
      "Liam Harper": [
        {"label": "Test Taken", "value": 22, "icon": Icons.assignment},
        {"label": "Avg Test Score", "value": 78, "icon": Icons.star},
        {
          "label": "Highest Test Score",
          "value": 85,
          "icon": Icons.emoji_events,
        },
        {"label": "Course Completed", "value": 4, "icon": Icons.school},
        {"label": "Avg Watch Time", "value": 70, "icon": Icons.access_time},
        {"label": "Chapters Completed", "value": 32, "icon": Icons.menu_book},
      ],
      "Olivia Reed": [
        {"label": "Test Taken", "value": 25, "icon": Icons.assignment},
        {"label": "Avg Test Score", "value": 85, "icon": Icons.star},
        {
          "label": "Highest Test Score",
          "value": 92,
          "icon": Icons.emoji_events,
        },
        {"label": "Course Completed", "value": 5, "icon": Icons.school},
        {"label": "Avg Watch Time", "value": 78, "icon": Icons.access_time},
        {"label": "Chapters Completed", "value": 38, "icon": Icons.menu_book},
      ],
      "Noah Foster": [
        {"label": "Test Taken", "value": 18, "icon": Icons.assignment},
        {"label": "Avg Test Score", "value": 72, "icon": Icons.star},
        {
          "label": "Highest Test Score",
          "value": 80,
          "icon": Icons.emoji_events,
        },
        {"label": "Course Completed", "value": 3, "icon": Icons.school},
        {"label": "Avg Watch Time", "value": 65, "icon": Icons.access_time},
        {"label": "Chapters Completed", "value": 28, "icon": Icons.menu_book},
      ],
      "Ava Morgan": [
        {"label": "Test Taken", "value": 26, "icon": Icons.assignment},
        {"label": "Avg Test Score", "value": 88, "icon": Icons.star},
        {
          "label": "Highest Test Score",
          "value": 95,
          "icon": Icons.emoji_events,
        },
        {"label": "Course Completed", "value": 5, "icon": Icons.school},
        {"label": "Avg Watch Time", "value": 82, "icon": Icons.access_time},
        {"label": "Chapters Completed", "value": 42, "icon": Icons.menu_book},
      ],
    };

    // Default data (when no student is selected)
    final RxList<Map<String, dynamic>> courses = <Map<String, dynamic>>[
      {"name": "Biology", "progress": 80, "icon": Icons.science},
      {"name": "Physics", "progress": 40, "icon": Icons.bubble_chart},
      {"name": "Chemistry", "progress": 60, "icon": Icons.biotech},
      {"name": "IT", "progress": 95, "icon": Icons.computer},
      {"name": "English", "progress": 75, "icon": Icons.menu_book},
      {"name": "History", "progress": 70, "icon": Icons.book},
    ].obs;

    final RxMap<String, dynamic> studentProgress =
        ({"ranking": 1, "total": 300, "status": "Excellent"}
                as Map<String, dynamic>)
            .obs;

    final RxList<Map<String, dynamic>> performance = <Map<String, dynamic>>[
      {"label": "Test Taken", "value": 25, "icon": Icons.assignment},
      {"label": "Avg Test Score", "value": 35, "icon": Icons.star},
      {"label": "Highest Test Score", "value": 50, "icon": Icons.emoji_events},
      {"label": "Course Completed", "value": 5, "icon": Icons.school},
      {"label": "Avg Watch Time", "value": 75, "icon": Icons.access_time},
      {"label": "Chapters Completed", "value": 21, "icon": Icons.menu_book},
    ].obs;

    // Function to update data based on selected student
    void updateStudentData(String studentName) {
      if (studentCoursesData.containsKey(studentName)) {
        courses.value = studentCoursesData[studentName]!;
        studentProgress.value = studentProgressData[studentName]!;
        performance.value = studentPerformanceData[studentName]!;
      }
    }

    Widget _buildCard(BuildContext context, {required Widget child}) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: child,
      );
    }

    final colorScheme = Theme.of(Get.context!).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: 10,
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () => Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Student Performance Analysis",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
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
                          ),
                          hint: Text(
                            "Select Subject",
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
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
                  const SizedBox(height: 8),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Students List
                                  SizedBox(
                                    width: constraints.maxWidth * 0.28,
                                    child: _buildCard(
                                      Get.context!,
                                      child: Obx(
                                        () => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Students List",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Expanded(
                                              child: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                  right: 16.0,
                                                ),
                                                itemCount: students.length,
                                                itemBuilder: (context, i) {
                                                  final st = students[i];
                                                  return Obx(() {
                                                    final isSelected =
                                                        selectedStudentName
                                                            .value ==
                                                        st["name"];

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 6.0,
                                                          ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            selectedStudentName
                                                                    .value =
                                                                st["name"]!;
                                                            updateStudentData(
                                                              st["name"]!,
                                                            );
                                                            print(
                                                              "Selected student: ${st["name"]}",
                                                            );
                                                          },
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          hoverColor:
                                                              colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                    0.15,
                                                                  ),
                                                          splashColor:
                                                              colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: isSelected
                                                                  ? colorScheme
                                                                        .primary
                                                                        .withOpacity(
                                                                          0.1,
                                                                        )
                                                                  : colorScheme
                                                                        .surface,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              border: Border.all(
                                                                color:
                                                                    isSelected
                                                                    ? colorScheme
                                                                          .primary
                                                                    : colorScheme
                                                                          .outline
                                                                          .withOpacity(
                                                                            0.3,
                                                                          ),
                                                                width:
                                                                    isSelected
                                                                    ? 2
                                                                    : 1,
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: colorScheme
                                                                      .shadow
                                                                      .withOpacity(
                                                                        0.05,
                                                                      ),
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        2,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            child: ListTile(
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical: 8,
                                                                  ),
                                                              leading: CircleAvatar(
                                                                backgroundColor:
                                                                    isSelected
                                                                    ? colorScheme
                                                                          .primary
                                                                    : colorScheme
                                                                          .primaryContainer,
                                                                child: Text(
                                                                  st["name"]![0],
                                                                  style: TextStyle(
                                                                    color:
                                                                        isSelected
                                                                        ? colorScheme
                                                                              .onPrimary
                                                                        : colorScheme
                                                                              .onPrimaryContainer,
                                                                    fontWeight:
                                                                        isSelected
                                                                        ? FontWeight
                                                                              .bold
                                                                        : FontWeight
                                                                              .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                st["name"] ??
                                                                    "",
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      isSelected
                                                                      ? colorScheme
                                                                            .primary
                                                                      : null,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              subtitle: Text(
                                                                st["role"] ??
                                                                    "",
                                                                style: TextStyle(
                                                                  color: colorScheme
                                                                      .onSurfaceVariant,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  /// Course Progress
                                  SizedBox(
                                    width: constraints.maxWidth * 0.42,
                                    child: _buildCard(
                                      Get.context!,
                                      child: Obx(
                                        () => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Course Progress",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Expanded(
                                              child: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                  right: 16.0,
                                                ),
                                                itemCount: courses.length,
                                                itemBuilder: (context, i) {
                                                  final c = courses[i];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 8,
                                                        ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: colorScheme
                                                            .primaryContainer,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        border: Border.all(
                                                          color: colorScheme
                                                              .primary
                                                              .withOpacity(0.2),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 48,
                                                            height: 48,
                                                            decoration: BoxDecoration(
                                                              color: colorScheme
                                                                  .surface,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                            child: Icon(
                                                              c["icon"],
                                                              color: colorScheme
                                                                  .primary,
                                                              size: 28,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              c["name"],
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: colorScheme
                                                                  .surface,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              "${c["progress"]}%",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    colorScheme
                                                                        .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                  const SizedBox(width: 12),

                                  /// Student Progress + Performance Overview
                                  SizedBox(
                                    width: constraints.maxWidth * 0.28,
                                    child: Column(
                                      children: [
                                        _buildCard(
                                          Get.context!,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      "Student Progress",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: colorScheme
                                                          .secondaryContainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Obx(
                                                      () => Text(
                                                        studentProgress["status"],
                                                        style: TextStyle(
                                                          color: colorScheme
                                                              .secondary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Student Ranking",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => Text(
                                                        "#${studentProgress["ranking"]} Rank",
                                                        style: TextStyle(
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorScheme
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => Text(
                                                        "Out of ${studentProgress["total"]} Students",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: colorScheme
                                                              .onSurfaceVariant
                                                              .withOpacity(0.8),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        Expanded(
                                          child: _buildCard(
                                            Get.context!,
                                            child: Obx(
                                              () => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Performance Overview",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Expanded(
                                                    child: GridView.builder(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            right: 8.0,
                                                          ),
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            childAspectRatio:
                                                                1.0,
                                                            crossAxisSpacing: 4,
                                                            mainAxisSpacing: 4,
                                                          ),
                                                      itemCount:
                                                          performance.length,
                                                      itemBuilder: (context, i) {
                                                        final p =
                                                            performance[i];
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color: colorScheme
                                                                .primaryContainer,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.all(
                                                                10,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    p["icon"],
                                                                    color: colorScheme
                                                                        .primary,
                                                                    size: 22,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      p["value"]
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            28,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: colorScheme
                                                                            .onSurface,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                p["label"],
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: colorScheme
                                                                      .onSurfaceVariant,
                                                                ),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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