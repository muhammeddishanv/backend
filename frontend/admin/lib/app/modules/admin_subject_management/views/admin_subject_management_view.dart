import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../global_widgets/search_bar.dart';
import '../../../routes/app_pages.dart';

class AdminSubjectManagementView extends GetResponsiveView {
  AdminSubjectManagementView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox(); // not needed
  @override
  Widget tablet() => const SizedBox(); // not needed

  @override
  Widget desktop() {
    /// List of subjects
    final RxList<Map<String, String>> subjects = <Map<String, String>>[
      {
        "title": "Introduction to Programming",
        "desc": "Learn the basics of coding with Python."
      },
      {
        "title": "Advanced Data Structures",
        "desc": "Explore complex data structures and algorithms."
      },
      {
        "title": "Machine Learning Fundamentals",
        "desc": "Dive into the world of machine learning with practical examples."
      },
    ].obs;

    /// List of chapters
    final RxList<Map<String, String>> chapters = <Map<String, String>>[
      {"title": "Chapter 1: Basics of Python", "lessons": "5 Lessons"},
      {"title": "Chapter 2: Control Structures", "lessons": "4 Lessons"},
    ].obs;

    /// Track edit state
    final RxSet<int> editingSubjects = <int>{}.obs;
    final RxSet<int> editingChapters = <int>{}.obs;

    /// Show Lessons Menu
    Future<void> _showLessonsMenu(
        BuildContext context, TapDownDetails details, int index) async {
      final ch = chapters[index];
      final lessonText = ch["lessons"] ?? "0 Lessons";

      final match = RegExp(r'(\d+)').firstMatch(lessonText);
      final totalLessons = match != null ? int.parse(match.group(1)!) : 0;

      final items = List.generate(totalLessons, (i) => "${i + 1} Lesson");
      items.add("+ Lesson");

      await showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        constraints: const BoxConstraints(
          maxHeight: 250,
          minWidth: 150,
          maxWidth: 180,
        ),
        items: items.map((lesson) {
          final isAdd = lesson == "+ Lesson";
          return PopupMenuItem<String>(
            value: null,
            enabled: false,
            child: InkWell(
              onTap: () {
                if (isAdd) {
                  Navigator.pop(context); // Close the popup menu
                  Get.toNamed(Routes.ADMIN_CREATE_LESSON);
                } else {
                  Navigator.pop(context); // Close the popup menu
                  Get.toNamed(Routes.ADMIN_EDIT_LESSON);
                }
              },
              child: Text(
                lesson,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: isAdd ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

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
      bool showCategory = true,
      bool showSubcategory = false,
    }) {
      return Row(
        children: [
          Flexible(
            flex: 3,
            child: AdminSearchBar(
              onChanged: (value) {},
              hintText: searchHint,
            ),
          ),
          const SizedBox(width: 10),
          if (showCategory) ...[
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
                  DropdownMenuItem(value: "Category 1", child: Text("Category 1")),
                  DropdownMenuItem(value: "Category 2", child: Text("Category 2")),
                  DropdownMenuItem(value: "Category 3", child: Text("Category 3")),
                  DropdownMenuItem(value: "Category 4", child: Text("Category 4")),
                  DropdownMenuItem(value: "Category 5", child: Text("Category 5")),
                ],
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 10),
          ],
          if (showSubcategory) ...[
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
                hint: const Text("select subcategory"),
                items: const [
                  DropdownMenuItem(value: "Subcategory 1", child: Text("Subcategory 1")),
                  DropdownMenuItem(value: "Subcategory 2", child: Text("Subcategory 2")),
                  DropdownMenuItem(value: "Subcategory 3", child: Text("Subcategory 3")),
                  DropdownMenuItem(value: "Subcategory 4", child: Text("Subcategory 4")),
                  DropdownMenuItem(value: "Subcategory 5", child: Text("Subcategory 5")),
                ],
                onChanged: (value) {},
              ),
            ),
          ],
          const SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: Text(addLabel,
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
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

    /// ---------------- SUBJECT ROW ----------------
    DataRow _buildRow(BuildContext context, int index) {
      final subj = subjects[index];
      final isEditing = editingSubjects.contains(index);

      return DataRow(
        onSelectChanged: (selected) {
          print("Tapped on entire subject row: ${subj["title"]}");
        },
        cells: [
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: subj["title"],
                    onChanged: (val) => subj["title"] = val,
                  )
                : Text(subj["title"] ?? ""),
          ),
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: subj["desc"],
                    onChanged: (val) => subj["desc"] = val,
                  )
                : Text(subj["desc"] ?? ""),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    if (isEditing) {
                      editingSubjects.remove(index);
                    } else {
                      editingSubjects.add(index);
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
                    // Delete functionality - no action needed as requested
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

    /// ---------------- CHAPTER ROW ----------------
    DataRow _buildChapterRow(BuildContext context, int index) {
      final ch = chapters[index];
      final isEditing = editingChapters.contains(index);

      return DataRow(
        cells: [
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: ch["title"],
                    onChanged: (val) => ch["title"] = val,
                  )
                : Text(ch["title"] ?? ""),
          ),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: (ch["lessons"] == "+ Lesson")
                  ? SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.ADMIN_CREATE_LESSON);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          "+ Lesson",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  : Builder(
                      builder: (ctx) {
                        return SizedBox(
                          height: 30,
                          child: TextButton(
                            onPressed: () {
                              final box = ctx.findRenderObject() as RenderBox;
                              final position = box.localToGlobal(Offset.zero);
                              _showLessonsMenu(
                                ctx,
                                TapDownDetails(globalPosition: position),
                                index,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft,
                            ),
                            child: Text(
                              ch["lessons"] ?? "",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    if (isEditing) {
                      editingChapters.remove(index);
                    } else {
                      editingChapters.add(index);
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
                    // Delete functionality - no action needed as requested
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
            selectedIndex: 3,
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
                      Text("Subject Management",
                          style: Theme.of(Get.context!)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(Get.context!)
                                      .colorScheme
                                      .onBackground)),
                      const SizedBox(height: 30),
                      Text("Subject List",
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildSearchRowWithDropdowns(
                        Get.context!,
                        searchHint: "search subjects",
                        addLabel: "Add Subject",
                        onAdd: () {
                          subjects.add(
                              {"title": "Subject Name", "desc": "Subject Description"});
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildCard(
                        Get.context!,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final col1 = constraints.maxWidth * 0.3;
                            final col2 = constraints.maxWidth * 0.5;
                            final col3 = constraints.maxWidth * 0.2;

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
                                        child: const Text("Subject Title")),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                        width: col2,
                                        child: const Text("Description")),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                        width: col3,
                                        child: const Text("Actions")),
                                  ),
                                ],
                                rows: List.generate(
                                    subjects.length,
                                    (i) => _buildRow(Get.context!, i)),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text("Chapter List",
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildSearchRowWithDropdowns(
                        Get.context!,
                        searchHint: "search chapters",
                        addLabel: "Add Chapter",
                        showCategory: false,
                        showSubcategory: true,
                        onAdd: () {
                          chapters.add(
                              {"title": "Chapter Title", "lessons": "+ Lesson"});
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildCard(
                        Get.context!,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final col1 = constraints.maxWidth * 0.3;
                            final col2 = constraints.maxWidth * 0.5;
                            final col3 = constraints.maxWidth * 0.2;

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
                                        child: const Text("Chapter Title")),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                        width: col2,
                                        child: const Text("Lessons")),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                        width: col3,
                                        child: const Text("Actions")),
                                  ),
                                ],
                                rows: List.generate(
                                    chapters.length,
                                    (i) => _buildChapterRow(Get.context!, i)),
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
