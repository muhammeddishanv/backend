import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
        "desc": "Learn the basics of coding with Python.",
        // 'uploaded' tracks whether thumbnail/assets for this subject are uploaded
        "uploaded": "false",
      },
      {
        "title": "Advanced Data Structures",
        "desc": "Explore complex data structures and algorithms.",
        "uploaded": "false",
      },
      {
        "title": "Machine Learning Fundamentals",
        "desc":
            "Dive into the world of machine learning with practical examples.",
        "uploaded": "false",
      },
    ].obs;

    /// Track edit state
    final RxSet<int> editingSubjects = <int>{}.obs;

    // Pagination state
    final int itemsPerPage = 7; // each page shows 8 subjects
    final RxInt currentPage = 1.obs;

    int totalPages() => ((subjects.length + itemsPerPage - 1) / itemsPerPage)
        .ceil()
        .clamp(1, 9999)
        .toInt();

    Widget _buildPagination(BuildContext context) {
      return Obx(() {
        final tp = totalPages();
        // Always show the pagination control, even when there's only a single page.
        // This ensures the pager is visible when there is e.g. only one subject.

        List<Widget> pages = [];
        pages.add(
          IconButton(
            onPressed: currentPage.value > 1 ? () => currentPage.value-- : null,
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );

        for (int i = 1; i <= tp; i++) {
          final isActive = i == currentPage.value;
          pages.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                height: 28,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(Get.context!).colorScheme.surfaceVariant,
                    minimumSize: const Size(28, 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => currentPage.value = i,
                  child: Text(
                    i.toString(),
                    style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        pages.add(
          IconButton(
            onPressed: currentPage.value < tp
                ? () => currentPage.value++
                : null,
            icon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );

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
                            ob
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
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
            child: AdminSearchBar(onChanged: (value) {}, hintText: searchHint),
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
                  DropdownMenuItem(
                    value: "Category 1",
                    child: Text("Category 1"),
                  ),
                  DropdownMenuItem(
                    value: "Category 2",
                    child: Text("Category 2"),
                  ),
                  DropdownMenuItem(
                    value: "Category 3",
                    child: Text("Category 3"),
                  ),
                  DropdownMenuItem(
                    value: "Category 4",
                    child: Text("Category 4"),
                  ),
                  DropdownMenuItem(
                    value: "Category 5",
                    child: Text("Category 5"),
                  ),
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
                  DropdownMenuItem(
                    value: "Subcategory 1",
                    child: Text("Subcategory 1"),
                  ),
                  DropdownMenuItem(
                    value: "Subcategory 2",
                    child: Text("Subcategory 2"),
                  ),
                  DropdownMenuItem(
                    value: "Subcategory 3",
                    child: Text("Subcategory 3"),
                  ),
                  DropdownMenuItem(
                    value: "Subcategory 4",
                    child: Text("Subcategory 4"),
                  ),
                  DropdownMenuItem(
                    value: "Subcategory 5",
                    child: Text("Subcategory 5"),
                  ),
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

    /// ---------------- ADD SUBJECT MODAL ----------------
    Future<void> _showAddSubjectDialog(BuildContext context) async {
      final colorScheme = Theme.of(context).colorScheme;
      final TextEditingController titleCtrl = TextEditingController();
      final TextEditingController descCtrl = TextEditingController();
      final TextEditingController instructorCtrl = TextEditingController();
      final TextEditingController durationCtrl = TextEditingController();
      final TextEditingController levelCtrl = TextEditingController();
      final TextEditingController priceCtrl = TextEditingController();
      final Rx<Uint8List?> thumbnail = Rx<Uint8List?>(null);
      final ImagePicker _picker = ImagePicker();

      Future<void> _pickThumbnail() async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          final bytes = await image.readAsBytes();
          thumbnail.value = bytes;
        }
      }

      Get.dialog(
        _standardDialogShell(
          maxWidth: 900,
          innerPadding: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 750),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- HEADER ----------
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Add Subject',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ---------- TITLE & DESCRIPTION ----------
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    label: 'Subject Title',
                                    hintText: 'Enter title',
                                    controller: titleCtrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _field(
                                    label: 'Subject Description',
                                    hintText: 'Enter description',
                                    controller: descCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ---------- THUMBNAIL (styled like fields; upload button themed like Create) ----------
                            Text(
                              'Thumbnail',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Obx(() {
                                // When no image: center instruction + Upload button.
                                // When image present: show preview near the top and pin the button to the bottom of the box.
                                if (thumbnail.value == null) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Drag and drop or browse to upload a thumbnail image for the subject.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 36,
                                        child: ElevatedButton(
                                          onPressed: _pickThumbnail,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                colorScheme.primary,
                                            foregroundColor:
                                                colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: const Text('Upload'),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // image is present
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // preview centered near the top
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        width: 160,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: colorScheme.outline
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: Image.memory(
                                            thumbnail.value!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // add explicit spacing between the image preview and the button
                                    const SizedBox(height: 12),
                                    // button (placed after the preview with some gap)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: SizedBox(
                                        height: 36,
                                        child: ElevatedButton(
                                          onPressed: _pickThumbnail,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                colorScheme.primary,
                                            foregroundColor:
                                                colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: const Text('Change'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            const SizedBox(height: 16),

                            // ---------- CATEGORY + SUBCATEGORY ----------
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: colorScheme.surface,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: colorScheme.outlineVariant,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('select category'),
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Cat1",
                                            child: Text("Category 1"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Cat2",
                                            child: Text("Category 2"),
                                          ),
                                        ],
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Subcategory',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: colorScheme.surface,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: colorScheme.outlineVariant,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('select subcategory'),
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Sub1",
                                            child: Text("Subcategory 1"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Sub2",
                                            child: Text("Subcategory 2"),
                                          ),
                                        ],
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ---------- INSTRUCTOR + DURATION ----------
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    label: 'Instructor',
                                    hintText: 'Enter Instructor name',
                                    controller: instructorCtrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _field(
                                    label: 'Duration',
                                    hintText: 'Enter Duration',
                                    controller: durationCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ---------- LEVEL + PRICE ----------
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    label: 'Level',
                                    hintText: 'Enter Level',
                                    controller: levelCtrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _field(
                                    label: 'Price',
                                    hintText: 'Enter Price',
                                    controller: priceCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // ---------- CREATE BUTTON (scrolls into view) ----------
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  final title = titleCtrl.text.trim();
                                  final desc = descCtrl.text.trim();
                                  if (title.isEmpty) {
                                    Get.snackbar(
                                      'Validation',
                                      'Please enter a subject title',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  // add minimal subject data to the subjects list so it appears in the table
                                  subjects.add({
                                    'title': title,
                                    'desc': desc,
                                    'uploaded': 'false',
                                  });

                                  // keep the user on the current page after creating a subject
                                  Get.back();
                                },
                                child: Text(
                                  'Create Subject',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        barrierDismissible: true,
      );
    }

    // Edit subject modal (mirrors Add modal but pre-fills fields and saves back)
    Future<void> _showEditSubjectDialog(BuildContext context, int index) async {
      final colorScheme = Theme.of(context).colorScheme;
      final subj = subjects[index];

      final TextEditingController titleCtrl = TextEditingController(
        text: subj['title'] ?? '',
      );
      final TextEditingController descCtrl = TextEditingController(
        text: subj['desc'] ?? '',
      );
      final TextEditingController instructorCtrl = TextEditingController(
        text: subj['instructor'] ?? '',
      );
      final TextEditingController durationCtrl = TextEditingController(
        text: subj['duration'] ?? '',
      );
      final TextEditingController levelCtrl = TextEditingController(
        text: subj['level'] ?? '',
      );
      final TextEditingController priceCtrl = TextEditingController(
        text: subj['price'] ?? '',
      );
      final Rx<Uint8List?> thumbnail = Rx<Uint8List?>(null);
      final ImagePicker _picker = ImagePicker();

      Future<void> _pickThumbnail() async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          final bytes = await image.readAsBytes();
          thumbnail.value = bytes;
        }
      }

      Get.dialog(
        _standardDialogShell(
          maxWidth: 900,
          innerPadding: 24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 750),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Edit Subject',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    label: 'Subject Title',
                                    hintText: 'Enter title',
                                    controller: titleCtrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _field(
                                    label: 'Subject Description',
                                    hintText: 'Enter description',
                                    controller: descCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Thumbnail',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Obx(() {
                                if (thumbnail.value == null) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Drag and drop or browse to upload a thumbnail image for the subject.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 36,
                                        child: ElevatedButton(
                                          onPressed: _pickThumbnail,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                colorScheme.primary,
                                            foregroundColor:
                                                colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: const Text('Change'),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        width: 160,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: colorScheme.outline
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: Image.memory(
                                            thumbnail.value!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: SizedBox(
                                        height: 36,
                                        child: ElevatedButton(
                                          onPressed: _pickThumbnail,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                colorScheme.primary,
                                            foregroundColor:
                                                colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: const Text('Change'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            // ---------- CATEGORY + SUBCATEGORY ----------
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: colorScheme.surface,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: colorScheme.outlineVariant,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('select category'),
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Cat1",
                                            child: Text("Category 1"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Cat2",
                                            child: Text("Category 2"),
                                          ),
                                        ],
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Subcategory',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: colorScheme.surface,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: colorScheme.outlineVariant,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('select subcategory'),
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Sub1",
                                            child: Text("Subcategory 1"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Sub2",
                                            child: Text("Subcategory 2"),
                                          ),
                                        ],
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    label: 'Instructor',
                                    hintText: 'Enter Instructor name',
                                    controller: instructorCtrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _field(
                                    label: 'Duration',
                                    hintText: 'Enter Duration',
                                    controller: durationCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    label: 'Level',
                                    hintText: 'Enter Level',
                                    controller: levelCtrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _field(
                                    label: 'Price',
                                    hintText: 'Enter Price',
                                    controller: priceCtrl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // apply changes back to the subjects list (minimal fields)
                                  subj['title'] = titleCtrl.text;
                                  subj['desc'] = descCtrl.text;
                                  // optional fields
                                  subj['instructor'] = instructorCtrl.text;
                                  subj['duration'] = durationCtrl.text;
                                  subj['level'] = levelCtrl.text;
                                  subj['price'] = priceCtrl.text;
                                  // thumbnail handling not persisted in current subjects map
                                  subjects.refresh();
                                  Get.back();
                                },
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        barrierDismissible: true,
      );
    }

    // Delete confirmation dialog (scoped to desktop so it can access `subjects`)
    Future<void> _showDeleteSubjectDialog(
      BuildContext context,
      int index,
    ) async {
      final colorScheme = Theme.of(context).colorScheme;
      final subj = subjects[index];

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
                        'Delete Subject',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete this subject?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'This action cannot be undone — subject and related data will be permanently removed.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          try {
                            subjects.removeAt(index);
                            // adjust current page if the removal left the current page empty
                            final tp = totalPages();
                            if (currentPage.value > tp)
                              currentPage.value = math.max(1, tp);

                            // close the dialog and notify
                            Get.back();
                            Get.snackbar(
                              'Deleted',
                              'Subject "${subj["title"] ?? ""}" was deleted',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } catch (e, st) {
                            // ensure the dialog still closes even if an error occurs
                            Get.back();
                            Get.snackbar(
                              'Error',
                              'Failed to delete subject',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            // keep a log for debugging
                            print(
                              'Error deleting subject at index $index: $e\n$st',
                            );
                          }
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
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
                    // Open edit modal for this subject
                    _showEditSubjectDialog(context, index);
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
                  onPressed: () => _showDeleteSubjectDialog(context, index),
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
                    // toggle uploaded state for this subject and refresh UI
                    final currentlyUploaded = subj['uploaded'] == 'true';
                    subj['uploaded'] = currentlyUploaded ? 'false' : 'true';
                    subjects.refresh();
                    Get.snackbar(
                      currentlyUploaded ? 'Upload removed' : 'Uploaded',
                      'Subject "${subj["title"] ?? ""}" ${currentlyUploaded ? 'marked as not uploaded' : 'subject uploaded'}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  icon: Icon(
                    Icons.upload,
                    color: subj['uploaded'] == 'true'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
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
                            Text(
                              "Subject Management",
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      Get.context!,
                                    ).colorScheme.onBackground,
                                  ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Subject List",
                              style: Theme.of(Get.context!).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            _buildSearchRowWithDropdowns(
                              Get.context!,
                              searchHint: "search subjects",
                              addLabel: "Add Subject",
                              onAdd: () {
                                _showAddSubjectDialog(Get.context!);
                              },
                              showSubcategory: true,
                            ),
                            const SizedBox(height: 15),
                            _buildCard(
                              Get.context!,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final col1 = constraints.maxWidth * 0.3;
                                  final col2 = constraints.maxWidth * 0.5;
                                  final col3 = constraints.maxWidth * 0.2;

                                  return Obx(() {
                                    final start =
                                        (currentPage.value - 1) * itemsPerPage;
                                    final end = math.min(
                                      start + itemsPerPage,
                                      subjects.length,
                                    );
                                    final visibleCount = (end - start).clamp(
                                      0,
                                      itemsPerPage,
                                    );

                                    final dataTable = DataTable(
                                      showCheckboxColumn: false,
                                      headingRowHeight: 45,
                                      dataRowHeight: 48,
                                      columnSpacing: 12,
                                      headingTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          Get.context!,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: SizedBox(
                                            width: col1,
                                            child: const Text('Title'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: col2,
                                            child: const Text('Description'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: col3,
                                            child: const Text('Actions'),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        for (int i = 0; i < visibleCount; i++)
                                          _buildRow(Get.context!, start + i),
                                      ],
                                    );

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [dataTable],
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
