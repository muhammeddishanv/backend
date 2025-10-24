// View for the Admin Edit Lesson screen.
// Contains responsive desktop layout, thumbnail & file pickers, and video link
// management UI. This file is purely a presentational widget and does not
// perform any network calls directly; controllers should handle data ops.
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../routes/app_pages.dart';

class AdminEditLessonView extends GetResponsiveView {
  AdminEditLessonView({super.key}) : super(alwaysUseBuilder: false);

  final ImagePicker _picker = ImagePicker();
  final Rx<Uint8List?> selectedThumbnail = Rx<Uint8List?>(null);
  final RxList<PlatformFile> selectedFiles = <PlatformFile>[].obs;
  final RxList<String> existingFiles = <String>[
    "Syllabus.pdf",
    "Chapter-1.pdf",
    "Chapter-2.pdf",
  ].obs;
  final RxList<Map<String, String>> videoLinks = <Map<String, String>>[
    {'link': '', 'title': ''},
  ].obs;
  final ScrollController _videoLinksScrollController = ScrollController();
  final RxInt editingVideoIndex = (-1).obs;

  // Function to add new video link pair
  void _addVideoLinkPair() {
    // Add new video link pair
    videoLinks.add({'link': '', 'title': ''});

    // Scroll down to show the newly added video link pair
    Future.delayed(const Duration(milliseconds: 200), () {
      _videoLinksScrollController.animateTo(
        _videoLinksScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  // Function to delete a video link
  void _deleteVideoLink(int index) {
    if (videoLinks.length > 1) {
      // Allow deletion if there are multiple video links
      videoLinks.removeAt(index);
    } else {
      // Show snackbar when trying to delete the last video link
      Get.snackbar(
        'Cannot Delete',
        'At least one video link is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(Get.context!).colorScheme.error,
        colorText: Theme.of(Get.context!).colorScheme.onError,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Function to edit a video link
  void _editVideoLink(int index) {
    if (editingVideoIndex.value == index) {
      // If already editing this video link, save and exit edit mode
      editingVideoIndex.value = -1;
    } else {
      // Enter edit mode for this video link
      editingVideoIndex.value = index;
    }
  }

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

  // Function to pick lesson materials (no images/videos/audio)
  Future<void> _pickLessonMaterials() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        // Document formats
        'pdf', 'doc', 'docx', 'txt', 'rtf', 'odt',
        // Spreadsheet formats
        'xls', 'xlsx', 'csv', 'ods',
        // Presentation formats
        'ppt', 'pptx', 'odp',
        // Archive formats
        'zip', 'rar', '7z', 'tar', 'gz',
        // Other common formats
        'xml', 'json', 'html', 'css', 'js', 'py', 'java', 'cpp', 'c',
        // E-book formats
        'epub', 'mobi', 'azw', 'azw3',
      ],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      selectedFiles.addAll(result.files);
    }
  }

  // Function to remove a selected file
  void _removeFile(int index) {
    selectedFiles.removeAt(index);
  }

  // Function to remove an existing file
  void _removeExistingFile(int index) {
    existingFiles.removeAt(index);
  }

  // Helper function to format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  @override
  Widget phone() => const SizedBox.shrink(); // not needed
  @override
  Widget tablet() => const SizedBox.shrink(); // not needed

  @override
  Widget desktop() {
    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      body: Row(
        children: [
          /// ---------- ADMIN SIDEBAR ----------
          AdminSidebar(
            selectedIndex: 7, // 7 for Edit Lesson
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () {
              // Handle logout here
              Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN);
            },
          ),

          /// ---------- MAIN CONTENT ----------
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
                        "Edit Lesson",
                        style: Theme.of(Get.context!).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                                _buildTextField(
                                  Get.context!,
                                  "Lesson Title",
                                  "enter lesson title",
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(
                                  Get.context!,
                                  "Lesson Description",
                                  "enter lesson description",
                                ),
                                const SizedBox(height: 20),
                                _buildThumbnailUploadBox(
                                  Get.context!,
                                  "Upload Thumbnail",
                                  "Drag and drop or browse to upload a thumbnail image for the lesson.",
                                ),
                                const SizedBox(height: 20),
                                // Video Links Section with proper label alignment
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Video Links",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(
                                          Get.context!,
                                        ).colorScheme.onBackground,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          220, // Increased height to properly show inner card
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Theme.of(Get.context!)
                                            .colorScheme
                                            .surfaceVariant
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Theme.of(Get.context!)
                                              .colorScheme
                                              .outline
                                              .withOpacity(0.2),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Scrollable content area
                                          Expanded(
                                            child: SingleChildScrollView(
                                              controller:
                                                  _videoLinksScrollController,
                                              child: Obx(
                                                () => Column(
                                                  children: videoLinks.asMap().entries.map((
                                                    entry,
                                                  ) {
                                                    int index = entry.key;
                                                    return Container(
                                                      width: double
                                                          .infinity, // Inner card full width
                                                      constraints:
                                                          const BoxConstraints(
                                                            minHeight:
                                                                100, // Minimum height to ensure complete visibility
                                                          ),
                                                      margin: EdgeInsets.only(
                                                        bottom:
                                                            index ==
                                                                videoLinks
                                                                        .length -
                                                                    1
                                                            ? 0
                                                            : 15,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Theme.of(
                                                                  Get.context!,
                                                                )
                                                                .colorScheme
                                                                .surfaceVariant
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              Theme.of(
                                                                    Get.context!,
                                                                  )
                                                                  .colorScheme
                                                                  .outline
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Video Link ${index + 1}",
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Theme.of(
                                                                    Get.context!,
                                                                  ).colorScheme.onBackground,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Obx(
                                                                    () => IconButton(
                                                                      onPressed: () =>
                                                                          _editVideoLink(
                                                                            index,
                                                                          ),
                                                                      icon: Icon(
                                                                        editingVideoIndex.value ==
                                                                                index
                                                                            ? Icons.save
                                                                            : Icons.edit,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            4,
                                                                          ),
                                                                      constraints: const BoxConstraints(
                                                                        minWidth:
                                                                            28,
                                                                        minHeight:
                                                                            28,
                                                                      ),
                                                                      color: Theme.of(
                                                                        Get.context!,
                                                                      ).colorScheme.primary,
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed: () =>
                                                                        _deleteVideoLink(
                                                                          index,
                                                                        ),
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 18,
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          4,
                                                                        ),
                                                                    constraints: const BoxConstraints(
                                                                      minWidth:
                                                                          28,
                                                                      minHeight:
                                                                          28,
                                                                    ),
                                                                    color: Theme.of(
                                                                      Get.context!,
                                                                    ).colorScheme.error,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  "enter video title",
                                                              filled: true,
                                                              fillColor: Theme.of(
                                                                Get.context!,
                                                              ).colorScheme.surfaceVariant,
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        14,
                                                                  ),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                            onChanged: (value) {
                                                              videoLinks[index]['title'] =
                                                                  value;
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  "enter video link",
                                                              filled: true,
                                                              fillColor: Theme.of(
                                                                Get.context!,
                                                              ).colorScheme.surfaceVariant,
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        14,
                                                                  ),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                            onChanged: (value) {
                                                              videoLinks[index]['link'] =
                                                                  value;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Add Link Button outside the container
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: _addVideoLinkPair,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            Get.context!,
                                          ).colorScheme.primary,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Add Link",
                                          style: TextStyle(
                                            color: Theme.of(
                                              Get.context!,
                                            ).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          // ---------------- RIGHT FORM ----------------
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildLessonMaterials(Get.context!),
                                const SizedBox(height: 20),
                                _buildTextField(
                                  Get.context!,
                                  "Cost",
                                  "enter lesson cost",
                                ),
                                const SizedBox(height: 20),
                                _buildDropdown(
                                  Get.context!,
                                  "Class",
                                  List.generate(5, (i) => "Class ${i + 1}"),
                                ),
                                const SizedBox(height: 20),
                                _buildDropdown(
                                  Get.context!,
                                  "Subject",
                                  List.generate(5, (i) => "Subject ${i + 1}"),
                                ),
                                const SizedBox(height: 20),
                                _buildDropdown(
                                  Get.context!,
                                  "Chapter",
                                  List.generate(5, (i) => "Chapter ${i + 1}"),
                                ),
                                const SizedBox(height: 20),
                                _buildDropdown(
                                  Get.context!,
                                  "Lesson",
                                  List.generate(5, (i) => "Lesson ${i + 1}"),
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
                              backgroundColor: Theme.of(
                                Get.context!,
                              ).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                color: Theme.of(
                                  Get.context!,
                                ).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                Get.context!,
                              ).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Delete Lesson",
                              style: TextStyle(
                                color: Theme.of(
                                  Get.context!,
                                ).colorScheme.onPrimary,
                              ),
                            ),
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

  // Thumbnail upload box - opens image picker
  Widget _buildThumbnailUploadBox(
    BuildContext context,
    String title,
    String desc,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          // Show selected image or description
          Obx(() {
            if (selectedThumbnail.value != null) {
              return Column(
                children: [
                  Container(
                    width: 160,
                    height: 90, // 16:9 aspect ratio (160:90)
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3),
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
              return Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                  fontSize: 13,
                ),
              );
            }
          }),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickThumbnailImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            child: Obx(
              () => Text(selectedThumbnail.value != null ? "Change" : "Upload"),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- REUSABLE WIDGETS ----------------

  static Widget _buildTextField(
    BuildContext context,
    String label,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildDropdown(
    BuildContext context,
    String label,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          menuMaxHeight: 250, // 🔥 scrollable dropdown
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text("select $label".toLowerCase()),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildLessonMaterials(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Lesson Materials",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            IconButton(
              onPressed: _pickLessonMaterials, // add file
              icon: const Icon(Icons.add, size: 18),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Existing files
        Obx(
          () => Column(
            children: existingFiles.asMap().entries.map((entry) {
              int index = entry.key;
              String file = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            file,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeExistingFile(index),
                      icon: const Icon(Icons.remove, size: 18),
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        // Newly selected files
        Obx(
          () => Column(
            children: selectedFiles.asMap().entries.map((entry) {
              int index = entry.key;
              PlatformFile file = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${file.name} (${_formatFileSize(file.size)})",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeFile(index),
                      icon: const Icon(Icons.remove, size: 18),
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
