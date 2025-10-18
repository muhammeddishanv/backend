import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_pages.dart';
import '../../../global_widgets/nav_bar.dart';

class AdminCreateQuizView extends GetResponsiveView {
  AdminCreateQuizView({super.key}) : super(alwaysUseBuilder: false);

  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _cardScrollController = ScrollController();
  final RxList<Map<String, dynamic>> questionsInCard = <Map<String, dynamic>>[].obs;
  final Rx<Uint8List?> selectedThumbnail = Rx<Uint8List?>(null);
  final RxInt editingQuestionIndex = (-1).obs;

  // Function to pick image for thumbnail
  Future<void> _pickThumbnailImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      selectedThumbnail.value = imageBytes;
    }
  }

  // Function to add new question within the same card and scroll within card
  void _addNewQuestion() {
    // Add new question within the same card
    questionsInCard.add({
      'question': '',
      'questionController': TextEditingController(),
      'selectedOption': RxString(''),
    });
    
    // Scroll down within the card to show the newly added question
    Future.delayed(const Duration(milliseconds: 200), () {
      _cardScrollController.animateTo(
        _cardScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  // Function to delete a question
  void _deleteQuestion(int index) {
    if (questionsInCard.length > 1) {
      // Dispose the controller to prevent memory leaks
      questionsInCard[index]['questionController']?.dispose();
      
      // Remove the question from the list
      questionsInCard.removeAt(index);
      
      // Reset edit mode if we were editing a question that was deleted or moved
      if (editingQuestionIndex.value >= questionsInCard.length) {
        editingQuestionIndex.value = -1;
      } else if (editingQuestionIndex.value == index) {
        editingQuestionIndex.value = -1;
      } else if (editingQuestionIndex.value > index) {
        editingQuestionIndex.value = editingQuestionIndex.value - 1;
      }
    } 
    else {
      // Show a message that at least one question is required
      Get.snackbar(
        'Cannot Delete',
        'At least one question is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Get.context!.theme.colorScheme.onError,
      );
    }
  }

  // Function to edit a question
  void _editQuestion(int index) {
    if (editingQuestionIndex.value == index) {
      // If already editing this question, save and exit edit mode
      editingQuestionIndex.value = -1;
    } else {
      // Enter edit mode for this question
      editingQuestionIndex.value = index;
    }
  }





  @override
  Widget phone() => const SizedBox.shrink(); // not needed
  @override
  Widget tablet() => const SizedBox.shrink(); // not needed

  @override
  Widget? desktop() {
    // Initialize with first question if empty
    if (questionsInCard.isEmpty) {
      questionsInCard.add({
        'question': '',
        'questionController': TextEditingController(),
        'selectedOption': RxString(''),
      });
    }

    // ---------------- REUSABLE WIDGETS ----------------
    Widget _buildTextField(String label, String hint, {int maxLines = 1, TextEditingController? controller, bool enabled = true}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Get.context!.theme.colorScheme.surfaceVariant,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildDropdown(String label, List<String> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            isExpanded: true,
            menuMaxHeight: 250,
            decoration: InputDecoration(
              filled: true,
              fillColor: Get.context!.theme.colorScheme.surfaceVariant,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text("select ${label.toLowerCase()}"),
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (val) {},
          ),
        ],
      );
    }

    Widget _buildUploadBox(String title, String desc) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.context!.theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: Get.context!.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Get.context!.theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            // Show selected image or description
            Obx(() {
              if (selectedThumbnail.value != null) {
                return Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120, // 16:9 aspect ratio (160:90)
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                          color: Get.context!.theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.memory(
                          selectedThumbnail.value!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Text(desc,
                    textAlign: TextAlign.center,
                    style: Get.context!.theme.textTheme.bodySmall?.copyWith(
                        color: Get.context!.theme.colorScheme.onSurfaceVariant));
              }
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickThumbnailImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.context!.theme.colorScheme.surface,
                foregroundColor: Get.context!.theme.colorScheme.onSurface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              child: Obx(() => Text(selectedThumbnail.value != null ? "Change" : "Upload")),
            ),
          ],
        ),
      );
    }

    Widget _buildRadioOption(
        String label, String groupValue, ValueChanged<String> onChanged, {bool enabled = true}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Get.context!.theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Radio<String>(
            value: label,
            groupValue: groupValue.isEmpty ? null : groupValue,
            onChanged: enabled ? (val) {
              if (val != null) onChanged(val);
            } : null,
            activeColor: Get.context!.theme.colorScheme.primary,
          ),
          title: Text(label),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          onTap: enabled ? () {
            onChanged(label);
          } : null,
        ),
      );
    }

    /// ---------------- MAIN UI ----------------
    return Scaffold(
      backgroundColor: Get.context!.theme.colorScheme.background,
      body: Row(
        children: [
          /// ---------- ADMIN SIDEBAR ----------
  AdminSidebar(
    selectedIndex: 8, // 8 for Create Quiz
    onMenuSelected: (index) {
      _navigateToPage(index);
    },
    onLogout: () {
      // Handle logout here
      Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN);
    },
  ),          /// ---------- MAIN CONTENT ----------
          Expanded(
            child: Scaffold(
              backgroundColor: Get.context!.theme.colorScheme.background,
              body: Padding(
                padding: const EdgeInsets.all(32.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Text(
                        "Create Quiz",
                        style: Get.context!.theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.context!.theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- LEFT FORM ----------------
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildDropdown("Class",
                                    List.generate(5, (i) => "Class ${i + 1}")),
                                const SizedBox(height: 20),
                                _buildDropdown("Subject",
                                    List.generate(5, (i) => "Subject ${i + 1}")),
                                const SizedBox(height: 20),
                                _buildDropdown("Chapter",
                                    List.generate(5, (i) => "Chapter ${i + 1}")),
                                const SizedBox(height: 20),
                                _buildDropdown(
                                    "Quiz Type", ["Lesson Quiz", "MCQ"]),
                                const SizedBox(height: 20),
                                _buildDropdown(
                                    "Quiz Appearance", ["Before", "In Between", "After"]),
                                const SizedBox(height: 20),
                                _buildUploadBox("Upload Images",
                                    "Drag and drop or browse to upload images."),
                              ],
                            ),
                          ),

                          const SizedBox(width: 40),

                          // ---------------- RIGHT FORM ----------------
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Scrollable Question Section containing multiple questions
                                Container(
                                  height: 600, // Increased height to show all 4 options
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Quiz Questions",
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 16),
                                        // Scrollable content area
                                        Expanded(
                                          child: SingleChildScrollView(
                                            controller: _cardScrollController,
                                            child: Obx(() => Column(
                                              children: questionsInCard.asMap().entries.map((entry) {
                                                int index = entry.key;
                                                var question = entry.value;
                                                
                                                return Container(
                                                  margin: EdgeInsets.only(bottom: index == questionsInCard.length - 1 ? 0 : 30),
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: Get.context!.theme.colorScheme.surfaceVariant.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: Get.context!.theme.colorScheme.outline.withOpacity(0.2),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Question ${index + 1}",
                                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                                          ),
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Obx(() => IconButton(
                                                                onPressed: () => _editQuestion(index),
                                                                icon: Icon(
                                                                  editingQuestionIndex.value == index ? Icons.save : Icons.edit, 
                                                                  size: 18
                                                                ),
                                                                padding: const EdgeInsets.all(4),
                                                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                                                color: Get.context!.theme.colorScheme.primary,
                                                              )),
                                                              IconButton(
                                                                onPressed: () => _deleteQuestion(index),
                                                                icon: const Icon(Icons.delete, size: 18),
                                                                padding: const EdgeInsets.all(4),
                                                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                                                color: Get.context!.theme.colorScheme.error,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 16),
                                                      _buildTextField(
                                                        "Type Question", 
                                                        "type here",
                                                        controller: question['questionController'],
                                                        enabled: true,
                                                      ),
                                                      const SizedBox(height: 16),
                                                      Text("Add Options",
                                                          style: Get.context!.theme.textTheme.titleSmall?.copyWith(
                                                              fontWeight: FontWeight.w500)),
                                                      const SizedBox(height: 8),
                                                      Obx(() => _buildRadioOption(
                                                          "Option 1", 
                                                          question['selectedOption'].value, 
                                                          (val) => question['selectedOption'].value = val,
                                                          enabled: true)),
                                                      Obx(() => _buildRadioOption(
                                                          "Option 2", 
                                                          question['selectedOption'].value, 
                                                          (val) => question['selectedOption'].value = val,
                                                          enabled: true)),
                                                      Obx(() => _buildRadioOption(
                                                          "Option 3", 
                                                          question['selectedOption'].value, 
                                                          (val) => question['selectedOption'].value = val,
                                                          enabled: true)),
                                                      Obx(() => _buildRadioOption(
                                                          "Option 4", 
                                                          question['selectedOption'].value, 
                                                          (val) => question['selectedOption'].value = val,
                                                          enabled: true)),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Add Question Button at the bottom of the card
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            onPressed: _addNewQuestion,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Get.context!.theme.colorScheme.primary,
                                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: Text(
                                              "Add Question",
                                              style: TextStyle(color: Get.context!.theme.colorScheme.onPrimary),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ---------------- BUTTONS ----------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Get.context!.theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Previous",
                                style: TextStyle(
                                    color: Get.context!
                                        .theme.colorScheme.onPrimary)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Get.context!.theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Submit",
                                style: TextStyle(
                                    color: Get.context!
                                        .theme.colorScheme.onPrimary)),
                          ),
                        ],
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
