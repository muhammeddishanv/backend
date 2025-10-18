import 'package:ed_tech/app/modules/student/change_password/change_password.controller.dart';
import 'package:ed_tech/app/modules/student/change_password/change_password.view.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:ed_tech/app/data/services/auth_service.dart';
import 'package:ed_tech/app/modules/home/views/about_us.view.dart';
import 'package:ed_tech/app/modules/home/views/contact_us.view.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

/*  
  This is the profile view for the user.
  It displays the user's profile information and allows them to edit their profile.
  It also provides options to contact support or learn more about the app.

  created by : Farseen
  date : 2025-08-13
  upated by : Muhammed Shabeer OP
  last updated : 2025-08-13
*/

class ProfileView extends GetResponsiveView {
  ProfileView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget? phone() {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 32,
            children: [
              // Profile Picture and User Info
              _buildProfileHeader(),
              // Profile Options List
              _buildProfileOptions(),
              // Logout Button
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 60,
              // changed to cached network image
              backgroundImage: CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
              ),
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Muhammed',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '9876543210',
          style: TextStyle(
            fontSize: 16,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      spacing: 10,
      children: [
        _optionTile(Icons.edit, 'Edit Profile', () {
          // Action for Edit Profile
          Get.toNamed(Routes.EDIT_PROFILE);
        }),
        _optionTile(Icons.lock_outline, 'Change password', () {
          // Action for Change password
          // Get.toNamed(Routes.CHANGE_PASSWORD);
          // Get.bottomSheet(
          //   ChangePasswordView(),
          //   settings: RouteSettings(name: Routes.CHANGE_PASSWORD),
          //   useRootNavigator: true,
          //   isScrollControlled: true,
          //   enterBottomSheetDuration: const Duration(milliseconds: 300),
          // );
          Get.put(ChangePasswordController());

          showModalBottomSheet(
            context: Get.context!,
            scrollControlDisabledMaxHeightRatio: 0.8,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
            ),
            routeSettings: RouteSettings(name: Routes.CHANGE_PASSWORD),
            useRootNavigator: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            builder: (context) {
              return ChangePasswordView();
            },
          );
        }),
        _optionTile(Icons.call_outlined, 'Contact us', () {
          // Action for Contact us
          // bottom Sheet
          Get.bottomSheet(
            ContactUsView(),
            settings: RouteSettings(name: Routes.CONTACT_US),
            useRootNavigator: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          );
        }),
        _optionTile(Icons.info_outline, 'About us', () {
          // Action for About us
          // bottom sheet
          Get.bottomSheet(
            AboutUsView(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          );
        }),
      ],
    );
  }

  Widget _optionTile(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        // tileColor: Get.theme.colorScheme.surfaceContainer,
        leading: Icon(icon, color: Get.theme.colorScheme.onSurface),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildLogoutButton() {
    RxBool isLoading = false.obs;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.colorScheme.error,
            foregroundColor: Get.theme.colorScheme.onError,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            // Action for Logout
            isLoading.value = true;
            await Future.delayed(const Duration(seconds: 1));
            Get.find<AuthService>().logout();
            Get.offAllNamed(Routes.AUTH);
          },
          child: isLoading.value
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.onError,
                  ),
                )
              : const Text('Logout', style: TextStyle(fontSize: 18)),
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
