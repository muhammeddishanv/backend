import 'package:cached_network_image/cached_network_image.dart';
import 'package:ed_tech/app/modules/student/edit_profile/edit_profile.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
    
  This is the edit profile view for the user.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Saabith k
  date : 2025-08-14
*/

class EditProfileView extends GetResponsiveView<EditProfileController> {
  EditProfileView({super.key}) : super(alwaysUseBuilder: false);

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();

  // State
  final RxString _gender = 'male'.obs;

  @override
  Widget? phone() {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildAvatar(),
                const SizedBox(height: 32),
                _buildSectionHeader('Basic Detail'),
                const SizedBox(height: 16),
                _buildLabeledTextField(
                  label: 'Full name',
                  hint: 'Enter full name',
                  controller: _fullNameController,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                _buildDobField(),
                const SizedBox(height: 20),
                _buildGender(),
                const SizedBox(height: 28),
                _buildSectionHeader('Contact Detail'),
                const SizedBox(height: 16),
                _buildLabeledTextField(
                  readOnly: true,
                  label: 'Mobile Number',
                  hint: 'Enter mobile number',
                ),
                const SizedBox(height: 20),
                _buildLabeledTextField(
                  readOnly: true,
                  label: 'Email Address',
                  hint: 'Enter email address',
                ),
                const SizedBox(height: 40),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final scheme = Get.theme.colorScheme;
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          const CircleAvatar(
            radius: 60,
            // changed to cached network image
            backgroundImage: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
            ),
            backgroundColor: Colors.transparent,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.onPrimary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // TODO: open image picker
                },
                child: Icon(
                  Icons.camera_alt,
                  color: scheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Get.theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    FormFieldValidator<String>? validator,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    final scheme = Get.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: !readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    size: 20,
                    color: scheme.onSurface.withOpacity(0.7),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDobField() {
    final theme = Get.theme;
    return _buildLabeledTextField(
      label: 'Date of birth',
      hint: 'Enter date of birth',
      controller: _dobController,
      suffixIcon: Icons.calendar_today_outlined,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      onTap: () async {
        final picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime(2000, 1, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(data: theme, child: child!),
        );
        if (picked != null) {
          _dobController.text =
              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        }
      },
    );
  }

  Widget _buildGender() {
    final scheme = Get.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderChip(
                label: 'Male',
                selected: _gender.value == 'male',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderChip(
                label: 'Female',
                selected: _gender.value == 'female',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderChip({required String label, required bool selected}) {
    final scheme = Get.theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? scheme.primary : scheme.outline.withOpacity(0.3),
          width: selected ? 2 : 1,
        ),
        color: selected ? scheme.primary.withOpacity(0.08) : Colors.transparent,
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outline,
                width: 2,
              ),
              color: selected ? scheme.primary : Colors.transparent,
            ),
            child: selected
                ? Icon(Icons.check, size: 12, color: scheme.onPrimary)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: selected ? scheme.primary : scheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    RxBool isLoading = false.obs;
    final scheme = Get.theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            isLoading.value = true;
            await Future.delayed(const Duration(milliseconds: 800));
            isLoading.value = false;

            Get.snackbar(
              'Success',
              'Profile updated successfully',
              backgroundColor: scheme.primary,
              colorText: scheme.onPrimary,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
          },
          child: isLoading.value
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: scheme.onPrimary,
                    strokeWidth: 2.4,
                  ),
                )
              : const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  @override
  Widget? tablet() {
    return phone();
  }

  @override
  Widget? desktop() {
    return phone();
  }
}
