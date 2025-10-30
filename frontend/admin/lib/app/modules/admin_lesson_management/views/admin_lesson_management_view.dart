// View: Admin Lesson Management
// Purpose: UI for listing, creating, and editing lessons within chapters and subjects in the admin panel.
// Heavy data logic stays in the controller; this file focuses purely on UI layout and widget structuring.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../global_widgets/search_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/admin_lesson_management_controller.dart';

class AdminLessonManagementView extends GetResponsiveView<AdminLessonManagementController> {
  AdminLessonManagementView({super.key});

  // Lesson data at class level
  final RxList<Map<String, String>> lessons = <Map<String, String>>[
    {
      "title": "Introduction to Programming",
      "desc": "Learn the basics of coding with Python.",
      "subject": "Computer",
      "chapter": "1",
      "lesson": "1"
    },
    {
      "title": "Advanced Data Structures",
      "desc": "Explore complex data structures and algorithms.",
      "subject": "Maths",
      "chapter": "5",
      "lesson": "3"
    },
    {
      "title": "Subject Name",
      "desc": "Subject description",
      "subject": "Subject",
      "chapter": "2",
      "lesson": "4"
    },
  ].obs;

  @override
  Widget phone() => const SizedBox();
  @override
  Widget tablet() => const SizedBox();

  // Form controllers at class level
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final videoLinksController = TextEditingController();
  final categoryRx = ''.obs;
  final subcategoryRx = ''.obs;
  final subjectRx = ''.obs;
  final chapterRx = ''.obs;
  final lessonRx = ''.obs;

  void showCreateLessonModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 150, vertical: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create Lesson",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Lesson Title"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: "enter lesson title...",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Lesson Description"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "enter lesson description...",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Upload Thumbnail",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Drag and drop or browse to upload a thumbnail image for the lesson",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Browse"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Video Links"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: videoLinksController,
                            decoration: InputDecoration(
                              hintText: "enter video links...",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Upload Subject Materials",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Drag and drop or browse to upload lesson materials",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Browse"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Category"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: categoryRx.value.isEmpty ? null : categoryRx.value,
                            decoration: InputDecoration(
                              hintText: "select category",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Category 1", child: Text("Category 1")),
                            ],
                            onChanged: (val) => categoryRx.value = val ?? '',
                          ),
                          const SizedBox(height: 16),
                          const Text("Subcategory"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: subcategoryRx.value.isEmpty ? null : subcategoryRx.value,
                            decoration: InputDecoration(
                              hintText: "select subcategory",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Subcategory 1", child: Text("Subcategory 1")),
                            ],
                            onChanged: (val) => subcategoryRx.value = val ?? '',
                          ),
                          const SizedBox(height: 16),
                          const Text("Subject"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: subjectRx.value.isEmpty ? null : subjectRx.value,
                            decoration: InputDecoration(
                              hintText: "select subject",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Subject 1", child: Text("Subject 1")),
                            ],
                            onChanged: (val) => subjectRx.value = val ?? '',
                          ),
                          const SizedBox(height: 16),
                          const Text("Subject Chapter"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: chapterRx.value.isEmpty ? null : chapterRx.value,
                            decoration: InputDecoration(
                              hintText: "select chapter",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Chapter 1", child: Text("Chapter 1")),
                            ],
                            onChanged: (val) => chapterRx.value = val ?? '',
                          ),
                          const SizedBox(height: 16),
                          const Text("Subject Lesson"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: lessonRx.value.isEmpty ? null : lessonRx.value,
                            decoration: InputDecoration(
                              hintText: "select lesson",
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Lesson 1", child: Text("Lesson 1")),
                            ],
                            onChanged: (val) => lessonRx.value = val ?? '',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: addNewLesson,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Create lesson"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigation handler
  void _showCreateLessonModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 150, vertical: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Lesson",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                // Form fields with controllers
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Lesson Title",
                    hintText: "enter lesson title...",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Lesson Description",
                    hintText: "enter lesson description...",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: addNewLesson,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text("Create lesson"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.ADMIN_DASHBOARD);
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

  void addNewLesson() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Theme.of(Get.context!).colorScheme.error,
        colorText: Theme.of(Get.context!).colorScheme.onError,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    lessons.add({
      "title": titleController.text,
      "desc": descriptionController.text,
      "subject": subjectRx.value,
      "chapter": chapterRx.value,
      "lesson": lessonRx.value,
      "videoLinks": videoLinksController.text,
    });

    // Clear form
    titleController.clear();
    descriptionController.clear();
    videoLinksController.clear();
    categoryRx.value = '';
    subcategoryRx.value = '';
    subjectRx.value = '';
    chapterRx.value = '';
    lessonRx.value = '';

    // Show success message
    Get.snackbar(
      'Success',
      'Lesson added successfully',
      backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
      colorText: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
      snackPosition: SnackPosition.TOP,
    );

    // Close the modal
    Get.back();
  }

  @override
  Widget desktop() {

    /// Function to add new lesson
    void addNewLesson() {
      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all required fields',
          backgroundColor: Theme.of(Get.context!).colorScheme.error,
          colorText: Theme.of(Get.context!).colorScheme.onError,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      lessons.add({
        "title": titleController.text,
        "desc": descriptionController.text,
        "subject": subjectRx.value,
        "chapter": chapterRx.value,
        "lesson": lessonRx.value,
        "videoLinks": videoLinksController.text,
      });

      // Clear form
      titleController.clear();
      descriptionController.clear();
      videoLinksController.clear();
      categoryRx.value = '';
      subcategoryRx.value = '';
      subjectRx.value = '';
      chapterRx.value = '';
      lessonRx.value = '';

      // Show success message
      Get.snackbar(
        'Success',
        'Lesson added successfully',
        backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
        colorText: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
        snackPosition: SnackPosition.TOP,
      );

      // Close the modal
      Get.back();
    }

    /// ---------------- FORM STATE ----------------

    /// ---------------- CARD CONTAINER ----------------
    Widget _buildCard(BuildContext context, {required Widget child}) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: child,
      );
    }

    /// ---------------- EDIT LESSON MODAL (Option B: pixel-perfect to given screenshot) ----------------
    void _showEditLessonModal(BuildContext context, int index) {
      final lesson = Map<String, String>.from(lessons[index]);

      // modal-level controllers
      final TextEditingController editTitleController =
          TextEditingController(text: lesson["title"] ?? "");
      final TextEditingController editDescriptionController =
          TextEditingController(text: lesson["desc"] ?? "");
      final TextEditingController editVideoLinksController =
          TextEditingController(text: lesson["videoLinks"] ?? "");
      final RxString editCategory = (lesson["category"] ?? '').obs;
      final RxString editSubcategory = (lesson["subcategory"] ?? '').obs;
      final RxString editSubject = RxString(lesson["subject"] ?? '');
      final RxString editChapter = RxString(lesson["chapter"] ?? '');
      final RxString editLesson = RxString(lesson["lesson"] ?? '');
      final RxList<String> materials = <String>[
        // If lesson already contains 'materials' as csv, split; else add placeholders for demo
        if ((lesson["materials"] ?? "").isNotEmpty)
          ...lesson["materials"]!.split(',')
        else
          "Syllabus.pdf".obs.value,
        if ((lesson["materials"] ?? "").isNotEmpty) ...[] else "Chapter-1.pdf",
        if ((lesson["materials"] ?? "").isNotEmpty) ...[] else "Chapter-2.pdf",
      ].map((e) => e.toString()).toList().obs;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            backgroundColor: Theme.of(ctx).colorScheme.surface,
            insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            child: StatefulBuilder(
              builder: (BuildContext innerCtx, StateSetter setState) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Edit Lesson",
                              style: Theme.of(ctx)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(ctx),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Two-column layout
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LEFT COLUMN
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text("Lesson Title"),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: editTitleController,
                                    decoration: InputDecoration(
                                      hintText: "enter Lesson title.....",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Description
                                  Text("Lesson Description"),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: editDescriptionController,
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      hintText: "enter Lesson description.....",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Upload thumbnail box
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(ctx).colorScheme.outline.withOpacity(0.45),
                                        style: BorderStyle.solid,
                                        width: 1.6,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Upload Thumbnail", style: TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        const Text("Drag and drop or browse to upload a thumbnail image for the Lesson."),
                                        const SizedBox(height: 14),
                                        ElevatedButton(
                                          onPressed: () {
                                            // implement real upload if desired
                                            Get.snackbar(
                                              'Info',
                                              'Thumbnail picker not implemented in this demo.',
                                              snackPosition: SnackPosition.TOP,
                                            );
                                          },
                                          child: const Text("Browse"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Video Links
                                  Text("Video Links"),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: editVideoLinksController,
                                    decoration: InputDecoration(
                                      hintText: "enter video links.....",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 28),

                            // RIGHT COLUMN
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Lesson Materials header with + icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Lesson Materials", style: TextStyle(fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline, color: Theme.of(ctx).colorScheme.primary),
                                        onPressed: () {
                                          // add new placeholder material (could open file picker)
                                          setState(() {
                                            materials.add("NewMaterial-${materials.length + 1}.pdf");
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // materials list
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(ctx).colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Theme.of(ctx).colorScheme.outline.withOpacity(0.15)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: materials.isEmpty
                                          ? [
                                              Text("No materials uploaded.")
                                            ]
                                          : materials.asMap().entries.map((entry) {
                                              final i = entry.key;
                                              final name = entry.value;
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        name,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(Icons.remove_circle_outline, color: Theme.of(ctx).colorScheme.error),
                                                          onPressed: () {
                                                            setState(() {
                                                              materials.removeAt(i);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Category dropdown
                                  Text("Category"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: editCategory.value.isEmpty ? null : editCategory.value,
                                    decoration: InputDecoration(
                                      hintText: "select class",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "Class 1", child: Text("Class 1")),
                                      DropdownMenuItem(value: "Class 2", child: Text("Class 2")),
                                    ],
                                    onChanged: (val) {
                                      setState(() => editCategory.value = val ?? '');
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // Subcategory dropdown
                                  Text("Subcategory"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: editSubcategory.value.isEmpty ? null : editSubcategory.value,
                                    decoration: InputDecoration(
                                      hintText: "select class",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "Subcat 1", child: Text("Subcat 1")),
                                    ],
                                    onChanged: (val) => setState(() => editSubcategory.value = val ?? ''),
                                  ),
                                  const SizedBox(height: 12),

                                  // Subject dropdown
                                  Text("Subject"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: editSubject.value.isEmpty ? null : editSubject.value,
                                    decoration: InputDecoration(
                                      hintText: "select subject",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "Computer", child: Text("Computer")),
                                      DropdownMenuItem(value: "Maths", child: Text("Maths")),
                                    ],
                                    onChanged: (val) => setState(() => editSubject.value = val ?? ''),
                                  ),
                                  const SizedBox(height: 12),

                                  // Subject Chapter dropdown
                                  Text("Subject Chapter"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: editChapter.value.isEmpty ? null : editChapter.value,
                                    decoration: InputDecoration(
                                      hintText: "select chapter",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "1", child: Text("Chapter 1")),
                                      DropdownMenuItem(value: "2", child: Text("Chapter 2")),
                                    ],
                                    onChanged: (val) => setState(() => editChapter.value = val ?? ''),
                                  ),
                                  const SizedBox(height: 12),

                                  // Subject Lesson dropdown
                                  Text("Subject Lesson"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: editLesson.value.isEmpty ? null : editLesson.value,
                                    decoration: InputDecoration(
                                      hintText: "select lesson",
                                      filled: true,
                                      fillColor: Theme.of(ctx).colorScheme.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "1", child: Text("Lesson 1")),
                                      DropdownMenuItem(value: "2", child: Text("Lesson 2")),
                                    ],
                                    onChanged: (val) => setState(() => editLesson.value = val ?? ''),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Buttons - Save Changes & Delete Lesson (right aligned)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Delete - red style
                            TextButton(
                              onPressed: () {
                                // Remove the lesson and close
                                lessons.removeAt(index);
                                Get.back(); // close modal
                                Get.snackbar(
                                  'Deleted',
                                  'Lesson deleted successfully',
                                  backgroundColor: Theme.of(ctx).colorScheme.error,
                                  colorText: Theme.of(ctx).colorScheme.onError,
                                  snackPosition: SnackPosition.TOP,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                "Delete Lesson",
                                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                              ),
                            ),
                            const SizedBox(width: 12),

                            ElevatedButton(
                              onPressed: () {
                                // Validate (simple validation)
                                if (editTitleController.text.trim().isEmpty ||
                                    editDescriptionController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill in title and description',
                                    backgroundColor: Theme.of(ctx).colorScheme.error,
                                    colorText: Theme.of(ctx).colorScheme.onError,
                                    snackPosition: SnackPosition.TOP,
                                  );
                                  return;
                                }

                                // Update the lessons list entry
                                lessons[index] = {
                                  "title": editTitleController.text.trim(),
                                  "desc": editDescriptionController.text.trim(),
                                  "subject": editSubject.value,
                                  "chapter": editChapter.value,
                                  "lesson": editLesson.value,
                                  // store videoLinks and materials as strings if needed
                                  "videoLinks": editVideoLinksController.text.trim(),
                                  "materials": materials.join(','),
                                  "category": editCategory.value,
                                  "subcategory": editSubcategory.value,
                                };

                                Get.back(); // close modal

                                Get.snackbar(
                                  'Success',
                                  'Lesson updated successfully',
                                  backgroundColor: Theme.of(ctx).colorScheme.primaryContainer,
                                  colorText: Theme.of(ctx).colorScheme.onPrimaryContainer,
                                  snackPosition: SnackPosition.TOP,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(ctx).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                "Save Changes",
                                style: TextStyle(color: Theme.of(ctx).colorScheme.onPrimary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    /// ---------------- SEARCH BAR & DROPDOWNS ----------------
    Widget _buildSearchRowWithDropdowns(BuildContext context,
        {required String searchHint,
        required String addLabel,
        required VoidCallback onAdd}) {
      return Row(
        children: [
          Flexible(
            flex: 3,
            child: AdminSearchBar(onChanged: (value) {}, hintText: searchHint),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 2,
            child: SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text("Select Category"),
                items: const [
                  DropdownMenuItem(
                    value: "Chapter 1",
                    child: Text(
                      "Chapter 1: Basics of Python",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Chapter 2",
                    child: Text(
                      "Chapter 2: Control Structures",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                onChanged: (value) {},
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 2,
            child: SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text("Select Subcategory"),
                items: const [
                  DropdownMenuItem(
                    value: "Subcategory 1",
                    child: Text("Subcategory 1: Python Basics",
                        overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem(
                    value: "Subcategory 2",
                    child: Text("Subcategory 2: Advanced Control Flow",
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
                onChanged: (value) {},
              ),
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
                label: Text(addLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      );
    }

    /// ---------------- ROW BUILDER ----------------
    DataRow _buildLessonRow(BuildContext context, int index) {
      final lesson = lessons[index];
      // Removed unused isEditing variable

      return DataRow(
        cells: [
          DataCell(Text(lesson["title"] ?? "")),
          DataCell(Text(lesson["desc"] ?? "")),
          DataCell(Text(lesson["subject"] ?? "")),
          DataCell(Text(lesson["chapter"] ?? "")),
          DataCell(Text(lesson["lesson"] ?? "")),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // EDIT ICON -> opens the new Edit Lesson modal (pixel-perfect)
              IconButton(
                onPressed: () {
                  _showEditLessonModal(context, index);
                },
                icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
              ),

              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          width: 400,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delete Lesson",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Are you sure you want to delete this lesson?",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "This action cannot be undone — lesson and related data will be permanently removed.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Cancel"),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      lessons.removeAt(index);
                                      Navigator.pop(context);
                                      Get.snackbar(
                                        'Success',
                                        'Lesson deleted successfully',
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        colorText: Theme.of(context).colorScheme.onError,
                                        snackPosition: SnackPosition.TOP,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                      foregroundColor: Theme.of(context).colorScheme.onError,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Confirm"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              ),

              // Upload placeholder action
              IconButton(
                onPressed: () {
                  Get.snackbar(
                    'Info',
                    'Upload action not implemented in demo.',
                    snackPosition: SnackPosition.TOP,
                  );
                },
                icon: Icon(Icons.upload, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          )),
        ],
      );
    }

    /// ---------------- CREATE LESSON MODAL (unchanged) ----------------
    void _showCreateLessonModal(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 250, vertical: 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800, // Reduced modal inner width
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Lesson",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),

                      /// Two-column layout
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// LEFT COLUMN
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lesson Title"),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: "enter lesson title…..",
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text("Lesson Description"),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: descriptionController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: "enter lesson description…..",
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.4),
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Upload Thumbnail",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                          "Drag and drop or browse to upload a thumbnail image for the lesson."),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Browse"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text("Video Links"),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: videoLinksController,
                                  decoration: InputDecoration(
                                    hintText: "enter video links…..",
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),

                          /// RIGHT COLUMN
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.4),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Upload Subject Materials",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                          "Drag and drop or browse to upload lesson materials."),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Browse"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  value: categoryRx.value.isEmpty ? null : categoryRx.value,
                                  decoration: InputDecoration(
                                    hintText: "select category",
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: "Category 1",
                                        child: Text("Category 1")),
                                  ],
                                  onChanged: (val) => categoryRx.value = val ?? '',
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: "select subcategory",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: "Subcategory 1",
                                        child: Text("Subcategory 1")),
                                  ],
                                  onChanged: (val) {},
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: subjectRx.value.isEmpty ? null : subjectRx.value,
                                  decoration: InputDecoration(
                                    hintText: "select subject",
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: "Subject 1",
                                        child: Text("Subject 1")),
                                  ],
                                  onChanged: (val) => subjectRx.value = val ?? '',
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: chapterRx.value.isEmpty ? null : chapterRx.value,
                                  decoration: InputDecoration(
                                    hintText: "select chapter",
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: "Chapter 1",
                                        child: Text("Chapter 1")),
                                  ],
                                  onChanged: (val) => chapterRx.value = val ?? '',
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: "select lesson",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: "Lesson 1",
                                        child: Text("Lesson 1")),
                                  ],
                                  onChanged: (val) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      /// Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: addNewLesson,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              "Create lesson",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    /// ---------------- MAIN UI ----------------
    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: 6,
            onMenuSelected: (index) => _navigateToPage(index),
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
                      Text("Lesson Management",
                          style: Theme.of(Get.context!)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      Text("Lesson List",
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildSearchRowWithDropdowns(
                        Get.context!,
                        searchHint: "Search lessons",
                        addLabel: "Add Lesson",
                        onAdd: () => showCreateLessonModal(Get.context!),
                      ),
                      const SizedBox(height: 15),
                      _buildCard(
                        Get.context!,
                        child: Obx(
                          () => DataTable(
                            showCheckboxColumn: false,
                            headingRowHeight: 45,
                            dataRowHeight: 55,
                            headingTextStyle: Theme.of(Get.context!)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            columns: const [
                              DataColumn(label: Text("Lesson Title")),
                              DataColumn(label: Text("Description")),
                              DataColumn(label: Text("Subject")),
                              DataColumn(label: Text("Chapter")),
                              DataColumn(label: Text("Lesson")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows: List.generate(
                              lessons.length,
                              (i) => _buildLessonRow(Get.context!, i),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Pagination dots at the bottom
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(Get.context!).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Previous page button
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                                  onPressed: () {
                                    // Implement previous page logic
                                  },
                                  visualDensity: VisualDensity.compact,
                                ),
                                // Page dots
                                ...List.generate(4, (index) {
                                  bool isActive = index == 0; // First page is active
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive 
                                        ? Theme.of(Get.context!).colorScheme.primary
                                        : Theme.of(Get.context!).colorScheme.outline.withOpacity(0.5),
                                    ),
                                  );
                                }),
                                // Next page button
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onPressed: () {
                                    // Implement next page logic
                                  },
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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

}  