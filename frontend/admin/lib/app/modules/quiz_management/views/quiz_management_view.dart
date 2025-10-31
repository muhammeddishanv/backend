import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../global_widgets/search_bar.dart';
import '../../../routes/app_pages.dart';

class QuizManagementView extends GetResponsiveView {
  QuizManagementView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox(); // not needed
  @override
  Widget tablet() => const SizedBox(); // not needed

  @override
  Widget desktop() {
    /// List of quizzes
    final RxList<Map<String, String>> quizzes = <Map<String, String>>[
      {
        "title": "Introduction to Programming",
        "subject": "Mathematics",
        "chapter": "1",
        "lesson": "1",
      },
      {
        "title": "Advanced Data Structures",
        "subject": "Physics",
        "chapter": "5",
        "lesson": "8",
      },
      {
        "title": "Subject Name",
        "subject": "Subject Name",
        "chapter": "6",
        "lesson": "7",
      },
    ].obs;

  // Pagination state
  final int itemsPerPage = 7; // each page shows 7 quizzes
    final RxInt currentPage = 1.obs;

    int totalPages() => ((quizzes.length + itemsPerPage - 1) / itemsPerPage).ceil().clamp(1, 9999).toInt();

    Widget _buildPagination(BuildContext context) {
      return Obx(() {
        final tp = totalPages();
        // Always show the pagination control, even when there's only a single page.
        // This ensures the pager is visible when there is e.g. only one subject.

        List<Widget> pages = [];
        pages.add(IconButton(
          onPressed: currentPage.value > 1 ? () => currentPage.value-- : null,
          icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ));

        for (int i = 1; i <= tp; i++) {
          final isActive = i == currentPage.value;
          pages.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              height: 28,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: isActive ? Theme.of(context).colorScheme.primary : Theme.of(Get.context!).colorScheme.surfaceVariant,
                  minimumSize: const Size(28, 28),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () => currentPage.value = i,
                child: Text(
                  i.toString(),
                  style: TextStyle(
                    color: isActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ));
        }

        pages.add(IconButton(
          onPressed: currentPage.value < tp ? () => currentPage.value++ : null,
          icon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ));

        return Align(
          alignment: Alignment.center,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: pages,
          ),
        );
      });
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

    // Reusable dialog shell to match the User Management dialog
    Widget _standardDialogShell({
      required Widget child,
      double maxWidth = 680,
      double innerPadding = 24,
    }) {
      final colorScheme = Theme.of(Get.context!).colorScheme;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(padding: EdgeInsets.all(innerPadding), child: child),
        ),
      );
    }

    // Field helper mimicking the one used in User Management to keep UI consistent
    Widget _field({
      required String label,
      required String hintText,
      bool isDateField = false,
      bool isPassword = false,
      BuildContext? context,
      TextEditingController? controller,
    }) {
      final colorScheme = Theme.of(Get.context!).colorScheme;
      final obscure = ValueNotifier<bool>(isPassword);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: obscure,
            builder: (_, ob, __) {
              return TextFormField(
                controller: controller,
                obscureText: ob && isPassword,
                readOnly: isDateField,
                onTap: isDateField && context != null
                    ? () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime(2003, 1, 1),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                      }
                    : null,
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            ob ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () => obscure.value = !ob,
                        )
                      : isDateField
                          ? Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            )
                          : null,
                ),
              );
            },
          ),
        ],
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

    /// ---------------- ADD QUIZ MODAL ----------------
  Future<void> _showAddQuizDialog(BuildContext context) async {
  final colorScheme = Theme.of(context).colorScheme;
  final TextEditingController quizIdCtrl = TextEditingController();
  final TextEditingController typeQuestionCtrl = TextEditingController();
  final TextEditingController explanationCtrl = TextEditingController();
  final TextEditingController option1Ctrl = TextEditingController();
  final TextEditingController option2Ctrl = TextEditingController();
  final TextEditingController option3Ctrl = TextEditingController();
  final TextEditingController option4Ctrl = TextEditingController();
  
  final RxString selectedQuestionNumber = ''.obs;
  final RxString selectedQuestionMark = ''.obs;

  Widget buildOptionField(String label, TextEditingController controller) {
    return Row(
      children: [
        Radio(value: label, groupValue: null, onChanged: (val) {}),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Get.dialog(
    Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 750),
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------- HEADER ----------
              Text('Create Quiz',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // ---------- ROW 1: Quiz ID & Question Number ----------
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: 'Quiz ID',
                      hintText: 'type here....',
                      controller: quizIdCtrl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Question Number:', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Obx(() => DropdownButtonFormField<String>(
                          value: selectedQuestionNumber.value.isEmpty ? null : selectedQuestionNumber.value,
                          decoration: InputDecoration(
                            hintText: 'select Question Number',
                            filled: true,
                            fillColor: colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                          ),
                          items: List.generate(20, (index) => (index + 1).toString())
                              .map((num) => DropdownMenuItem(value: num, child: Text(num)))
                              .toList(),
                          onChanged: (value) => selectedQuestionNumber.value = value ?? '',
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ---------- ROW 2: Type Question & Question Mark ----------
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: 'Type Question',
                      hintText: 'type here....',
                      controller: typeQuestionCtrl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Question Mark:', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Obx(() => DropdownButtonFormField<String>(
                          value: selectedQuestionMark.value.isEmpty ? null : selectedQuestionMark.value,
                          decoration: InputDecoration(
                            hintText: 'select Question Mark',
                            filled: true,
                            fillColor: colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                          ),
                          items: ['1', '2', '3', '4', '5']
                              .map((mark) => DropdownMenuItem(value: mark, child: Text(mark)))
                              .toList(),
                          onChanged: (value) => selectedQuestionMark.value = value ?? '',
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ---------- ROW 3: Add Options & Add Image ----------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Add Options
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Options:', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
                        buildOptionField('Option 1', option1Ctrl),
                        const SizedBox(height: 8),
                        buildOptionField('Option 2', option2Ctrl),
                        const SizedBox(height: 8),
                        buildOptionField('Option 3', option3Ctrl),
                        const SizedBox(height: 8),
                        buildOptionField('Option 4', option4Ctrl),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right: Add Image
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Image:', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outlineVariant, style: BorderStyle.solid, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Upload Images',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Drag and drop or browse to upload images.',
                                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle image upload
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.surfaceVariant,
                                  foregroundColor: colorScheme.onSurface,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Upload'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle Add Question
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Add Question'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ---------- Explanation ----------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explanation:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: explanationCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'type here....',
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ---------- BUTTONS ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Previous
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar('Success', 'Quiz created successfully', snackPosition: SnackPosition.BOTTOM);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

  // Edit quiz modal - similar to Create Quiz but with "Edit Quiz" title
  Future<void> _showEditQuizDialog(BuildContext context, int index) async {
    final colorScheme = Theme.of(context).colorScheme;
    final quiz = quizzes[index];

    final TextEditingController quizIdCtrl = TextEditingController(text: quiz['title'] ?? '');
    final TextEditingController typeQuestionCtrl = TextEditingController();
    final TextEditingController explanationCtrl = TextEditingController();
    final TextEditingController option1Ctrl = TextEditingController();
    final TextEditingController option2Ctrl = TextEditingController();
    final TextEditingController option3Ctrl = TextEditingController();
    final TextEditingController option4Ctrl = TextEditingController();
    
    final RxString selectedQuestionNumber = (quiz['chapter'] ?? '').obs;
    final RxString selectedQuestionMark = ''.obs;

    Widget buildOptionField(String label, TextEditingController controller) {
      return Row(
        children: [
          Radio(value: label, groupValue: null, onChanged: (val) {}),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Get.dialog(
      Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 800,
          constraints: const BoxConstraints(maxHeight: 750),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------- HEADER ----------
                Text('Edit Quiz',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                // ---------- ROW 1: Quiz ID & Question Number ----------
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        label: 'Quiz ID',
                        hintText: 'type here....',
                        controller: quizIdCtrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Question Number:', style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Obx(() => DropdownButtonFormField<String>(
                            value: selectedQuestionNumber.value.isEmpty ? null : selectedQuestionNumber.value,
                            decoration: InputDecoration(
                              hintText: 'select Question Number',
                              filled: true,
                              fillColor: colorScheme.surface,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colorScheme.outlineVariant),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colorScheme.outlineVariant),
                              ),
                            ),
                            items: List.generate(20, (index) => (index + 1).toString())
                                .map((num) => DropdownMenuItem(value: num, child: Text(num)))
                                .toList(),
                            onChanged: (value) => selectedQuestionNumber.value = value ?? '',
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---------- ROW 2: Type Question & Question Mark ----------
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        label: 'Type Question',
                        hintText: 'type here....',
                        controller: typeQuestionCtrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Question Mark:', style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Obx(() => DropdownButtonFormField<String>(
                            value: selectedQuestionMark.value.isEmpty ? null : selectedQuestionMark.value,
                            decoration: InputDecoration(
                              hintText: 'select Question Mark',
                              filled: true,
                              fillColor: colorScheme.surface,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colorScheme.outlineVariant),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colorScheme.outlineVariant),
                              ),
                            ),
                            items: ['1', '2', '3', '4', '5']
                                .map((mark) => DropdownMenuItem(value: mark, child: Text(mark)))
                                .toList(),
                            onChanged: (value) => selectedQuestionMark.value = value ?? '',
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ---------- ROW 3: Add Options & Add Image ----------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Add Options
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Options:', style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          buildOptionField('Option 1', option1Ctrl),
                          const SizedBox(height: 8),
                          buildOptionField('Option 2', option2Ctrl),
                          const SizedBox(height: 8),
                          buildOptionField('Option 3', option3Ctrl),
                          const SizedBox(height: 8),
                          buildOptionField('Option 4', option4Ctrl),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right: Add Image
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Image:', style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outlineVariant, style: BorderStyle.solid, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Upload Images',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('Drag and drop or browse to upload images.',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle image upload
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.surfaceVariant,
                                    foregroundColor: colorScheme.onSurface,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Upload'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Add Question
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Add Question'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ---------- Explanation ----------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Explanation:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: explanationCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'type here....',
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ---------- BUTTONS ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Previous
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Previous'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        quiz['title'] = quizIdCtrl.text;
                        quizzes.refresh();
                        Get.back();
                        Get.snackbar('Success', 'Quiz updated successfully', snackPosition: SnackPosition.BOTTOM);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Delete confirmation dialog (scoped to desktop so it can access `quizzes`)
  Future<void> _showDeleteQuizDialog(BuildContext context, int index) async {
    final colorScheme = Theme.of(context).colorScheme;
    final quiz = quizzes[index];

    await Get.dialog(
      _standardDialogShell(
        maxWidth: 520,
        innerPadding: 20,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Delete Quiz',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_rounded, color: colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete this quiz?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone — quiz and related data will be permanently removed.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary),
                        foregroundColor: colorScheme.onPrimary,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('Cancel', style: TextStyle(color: colorScheme.primary)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        try {
                          quizzes.removeAt(index);
                          // adjust current page if the removal left the current page empty
                          final tp = totalPages();
                          if (currentPage.value > tp) currentPage.value = math.max(1, tp);

                          // close the dialog and notify
                          Get.back();
                          Get.snackbar('Deleted', 'Quiz "${quiz["title"] ?? ""}" was deleted', snackPosition: SnackPosition.BOTTOM);
                        } catch (e, st) {
                          // ensure the dialog still closes even if an error occurs
                          Get.back();
                          Get.snackbar('Error', 'Failed to delete quiz', snackPosition: SnackPosition.BOTTOM);
                          // keep a log for debugging
                          print('Error deleting quiz at index $index: $e\n$st');
                        }
                      },
                      child: Text('Confirm', style: TextStyle(color: colorScheme.onPrimary)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

    /// ---------------- QUIZ ROW ----------------
    DataRow _buildRow(BuildContext context, int index) {
      final quiz = quizzes[index];

      return DataRow(
        onSelectChanged: (selected) {
          print("Tapped on entire quiz row: ${quiz["title"]}");
        },
        cells: [
          DataCell(Text(quiz["title"] ?? "")),
          DataCell(Text(quiz["subject"] ?? "")),
          DataCell(Text(quiz["chapter"] ?? "")),
          DataCell(Text(quiz["lesson"] ?? "")),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    _showEditQuizDialog(context, index);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeleteQuizDialog(context, index),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Navigate to quiz details or questions
                    Get.toNamed(Routes.ADMIN_CREATE_QUIZ);
                  },
                  icon: Icon(
                    Icons.upload,
                    color: Theme.of(context).colorScheme.primary,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quiz Management",
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(Get.context!)
                                            .colorScheme
                                            .onBackground)),
                            const SizedBox(height: 30),
                            Text("quiz List",
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            _buildSearchRowWithDropdowns(
                              Get.context!,
                              searchHint: "Search Quiz Title",
                              addLabel: "Create Quiz",
                              onAdd: () {
                                _showAddQuizDialog(Get.context!);
                              },
                              showSubcategory: true,
                            ),
                            const SizedBox(height: 15),
                            _buildCard(
                              Get.context!,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final col1 = constraints.maxWidth * 0.25;
                                  final col2 = constraints.maxWidth * 0.25;
                                  final col3 = constraints.maxWidth * 0.15;
                                  final col4 = constraints.maxWidth * 0.15;
                                  final col5 = constraints.maxWidth * 0.2;

                                  return Obx(() {
                                    final start = (currentPage.value - 1) * itemsPerPage;
                                    final end = math.min(start + itemsPerPage, quizzes.length);
                                    final visibleCount = (end - start).clamp(0, itemsPerPage);

                                    final dataTable = DataTable(
                                      showCheckboxColumn: false,
                                      headingRowHeight: 45,
                                      dataRowHeight: 48,
                                      columnSpacing: 12,
                                      headingTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(Get.context!).colorScheme.onSurfaceVariant,
                                      ),
                                      columns: [
                                        DataColumn(label: SizedBox(width: col1, child: const Text('Quiz Title'))),
                                        DataColumn(label: SizedBox(width: col2, child: const Text('Subject'))),
                                        DataColumn(label: SizedBox(width: col3, child: const Text('chapter'))),
                                        DataColumn(label: SizedBox(width: col4, child: const Text('Lesson'))),
                                        DataColumn(label: SizedBox(width: col5, child: const Text('Actions'))),
                                      ],
                                      rows: [
                                        for (int i = 0; i < visibleCount; i++)
                                          _buildRow(Get.context!, start + i)
                                      ],
                                    );

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        dataTable,
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // pagination centered at bottom of page
                    Center(child: _buildPagination(Get.context!)),
                  ],
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