import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_user_management_controller.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../global_widgets/search_bar.dart';
import '../../../routes/app_pages.dart';

class AdminUserManagementView
    extends GetResponsiveView<AdminUserManagementController> {
  AdminUserManagementView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox.shrink();
  @override
  Widget tablet() => const SizedBox.shrink();

  // Single source of truth for dialog width
  static const double _dialogMaxWidth = 680;

  @override
  Widget desktop() {
    final colorScheme = Theme.of(Get.context!).colorScheme;
    final String profilePlaceholder =
        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        children: [
          // Assuming AdminSidebar is defined elsewhere
          AdminSidebar(
            selectedIndex: 1,
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () {
              Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User Management",
                        style: Theme.of(Get.context!).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: AdminSearchBar(
                              hintText: "Search users",
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(width: 16),
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
                                print("Selected: $value");
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _showAddUserDialog(Get.context!),
                            child: Text(
                              "+ Add User",
                              style: TextStyle(color: colorScheme.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// User Table
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: SingleChildScrollView(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                cardColor: Colors.transparent,
                                dividerColor: colorScheme.outlineVariant,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  headingRowHeight: 45,
                                  dataRowHeight: 65,
                                  columnSpacing: 16,
                                  horizontalMargin: 16,
                                  headingTextStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onBackground,
                                      ),
                                  columns: const [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 50,
                                        child: Text("Photo"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        flex: 3,
                                        child: Text("Name"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        flex: 2,
                                        child: Text("Role"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        flex: 2,
                                        child: Text("Status"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        flex: 3,
                                        child: Text("Actions"),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    _buildUserDataRow(
                                      context,
                                      profilePlaceholder,
                                      "Sophia Clark",
                                      "Student",
                                      true,
                                      true,
                                    ),
                                    _buildUserDataRow(
                                      context,
                                      profilePlaceholder,
                                      "Ethan Miller",
                                      "Student",
                                      true,
                                      true,
                                    ),
                                    _buildUserDataRow(
                                      context,
                                      profilePlaceholder,
                                      "Ava Taylor",
                                      "Student",
                                      false,
                                      true,
                                    ),
                                    _buildUserDataRow(
                                      context,
                                      profilePlaceholder,
                                      "Aiden Lee",
                                      "Admin",
                                      false,
                                      false,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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

  DataRow _buildUserDataRow(
    BuildContext context,
    String photo,
    String name,
    String role,
    bool online,
    bool isStudent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return DataRow(
      onSelectChanged: (_) {},
      cells: [
        DataCell(
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(photo),
            backgroundColor: colorScheme.surfaceVariant,
          ),
        ),
        DataCell(Text(name)),
        DataCell(
          Text(
            role,
            style: TextStyle(
              color: role == "Admin"
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(_statusPill(context, online)),
        // ------------------------------------------
        // DataCell Content (Actions Column) - UPDATED TO USE CHIPS
        // ------------------------------------------
        DataCell(
          Row(
            children: [
              _actionPill(
                context,
                "Edit",
                onTap: () => _showEditUserDialog(context),
              ),
              const SizedBox(width: 8),

              _actionPill(context, "Unlock", onTap: () {}),
              const SizedBox(width: 8),

              // This chip is now unconditional
              _actionPill(
                context,
                "View Progress",
                onTap: () => Get.toNamed(Routes.ADMIN_PERFORMANCE_ANALYSIS),
                // Uses primaryContainer colors to distinguish it slightly
                backgroundColor: colorScheme.primaryContainer.withOpacity(0.5),
                textColor: colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Helper Widget for the Chips - UPDATED WITH HOVER EFFECT
  // ------------------------------------------
  Widget _actionPill(
    BuildContext context,
    String label, {
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final RxBool hovered = false.obs;
    // Defaulting to the same style as 'Edit' and 'Unlock'
    final defaultBg = colorScheme.secondaryContainer;
    final defaultText = colorScheme.onSecondaryContainer;

    return Obx(() {
      final Color bg = backgroundColor ?? defaultBg;
      final Color hoverBg = bg.withOpacity(hovered.value ? 0.7 : 1.0);
      final Color textCol = textColor ?? defaultText;

      return MouseRegion(
        onEnter: (_) => hovered.value = true,
        onExit: (_) => hovered.value = false,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: hoverBg,
              borderRadius: BorderRadius.circular(999),
              // Optionally add a slight shadow or border on hover
              border: hovered.value
                  ? Border.all(
                      color: (textColor ?? colorScheme.primary).withOpacity(
                        0.5,
                      ),
                      width: 0.5,
                    )
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textCol,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _statusPill(BuildContext context, bool online) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: online ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            online ? "Online" : "Offline",
            style: TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
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

  // ------------------------------------------
  // DIALOG AND HELPER METHODS
  // ------------------------------------------

  Widget _standardDialogShell({
    required Widget child,
    double maxWidth = _dialogMaxWidth,
  }) {
    final colorScheme = Theme.of(Get.context!).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Get.dialog(
      _standardDialogShell(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit User",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              _field(label: "Full Name", hintText: "Enter Full Name"),
              const SizedBox(height: 16),
              _field(label: "Email", hintText: "Enter Email"),
              const SizedBox(height: 16),
              _field(label: "Role", hintText: "Enter Role"),
              const SizedBox(height: 16),
              _field(
                label: "Password",
                hintText: "Enter Password",
                isPassword: true,
              ),
              const SizedBox(height: 16),
              _field(
                label: "Confirm Password",
                hintText: "Re-enter Password",
                isPassword: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "Save Changes",
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
      barrierDismissible: true,
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final RxString selectedGender = 'Male'.obs;

    Get.dialog(
      _standardDialogShell(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add User",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Profile Photo",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text("Upload Profile photo")),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: "Full Name",
                      hintText: "Enter Full Name",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(label: "Email", hintText: "Enter Email"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: "Phone Number",
                      hintText: "Enter Phone Number",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      label: "Date of Birth",
                      hintText: "Select Date of Birth",
                      isDateField: true,
                      context: context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                "Gender",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: ["Male", "Female", "Other"].map((g) {
                    final isSelected = selectedGender.value == g;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: OutlinedButton(
                        onPressed: () => selectedGender.value = g,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          g,
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: "Password",
                      hintText: "Enter Password",
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      label: "Confirm Password",
                      hintText: "Re-Enter Password",
                      isPassword: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: "Category",
                      hintText: "Enter Category",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(label: "Subject", hintText: "Enter Subject"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "Create User",
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
      barrierDismissible: true,
    );
  }

  Widget _field({
    required String label,
    required String hintText,
    bool isDateField = false,
    bool isPassword = false,
    BuildContext? context,
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
}