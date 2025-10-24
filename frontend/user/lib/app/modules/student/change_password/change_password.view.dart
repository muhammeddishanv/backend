import 'package:ed_tech/app/core/utils/extensions/input_decorations.dart';
import 'package:ed_tech/app/core/utils/functions/form_validation_helper.dart';
import 'package:ed_tech/app/modules/student/change_password/change_password.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*  
  This is the change password view for the user.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Muhammed Shabeer OP
  date : 2025-08-13
  updated by: Muhammed Shabeer OP
  updated date : 2025-08-14
*/

class ChangePasswordView extends GetResponsiveView<ChangePasswordController> {
  ChangePasswordView({super.key}) : super(alwaysUseBuilder: false);
  static final formKey = GlobalKey<FormState>();

  final _obscureOld = true.obs;
  final _obscureNew = true.obs;
  final _obscureConfirm = true.obs;

  @override
  Widget? phone() {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Get.theme.primaryColor,
        foregroundColor: Get.theme.colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Password Fields
                _buildPasswordFields(),
                const SizedBox(height: 40),
                // Save Button
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      spacing: 20,
      children: [
        _buildPasswordField(
          label: 'Old Password',
          controller: controller.oldPasswordController,
          obscure: _obscureOld,
          onToggle: () => _obscureOld.value = !_obscureOld.value,
        ),
        _buildPasswordField(
          label: 'New Password',
          controller: controller.newPasswordController,
          obscure: _obscureNew,
          onToggle: () => _obscureNew.value = !_obscureNew.value,
        ),
        _buildPasswordField(
          label: 'Confirm Password',
          controller: controller.confirmPasswordController,
          obscure: _obscureConfirm,
          onToggle: () => _obscureConfirm.value = !_obscureConfirm.value,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required RxBool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Get.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            // canRequestFocus: false,
            controller: controller,
            validator: FormValidationHelper.validatePassword,
            decoration: inputDecoration(label, hint: "******").copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  !obscure.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Get.theme.hintColor,
                ),
                onPressed: () {
                  obscure.value = !obscure.value;
                },
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            obscureText: obscure.value,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    RxBool isLoading = false.obs;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            // TODO: Implement save logic
            isLoading.value = true;
            await Future.delayed(const Duration(seconds: 1));
            isLoading.value = false;
            // Add your password change logic here
          },
          child: isLoading.value
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                )
              : const Text('Save', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  @override
  Widget? tablet() {
    return super.tablet();
  }

  @override
  Widget? desktop() {
    return super.desktop();
  }
}
