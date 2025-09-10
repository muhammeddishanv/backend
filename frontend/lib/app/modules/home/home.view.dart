import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/global_widgets/custom_nav_bar.dart';
import 'package:ed_tech/app/modules/home/views/subjects.view.dart';
import 'package:ed_tech/app/modules/home/views/dashboard.view.dart';
import 'package:ed_tech/app/modules/home/views/profile.view.dart';

import 'home.controller.dart';

/*
  This is the view for the home module.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Muhammed Shabeer OP
  date : 2025-08-07
  updated date : 2025-08-07
*/

class HomeView extends GetResponsiveView<HomeController> {
  HomeView({super.key}) : super(alwaysUseBuilder: false);
  @override
  Widget phone() {
    return _buildHomeView();
  }

  @override
  Widget tablet() => Icon(Icons.tablet, size: 75);
  @override
  Widget desktop() => Icon(Icons.desktop_mac, size: 75);

  Scaffold _buildHomeView() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.colorScheme.primary,
        elevation: 8,
        shape: const CircleBorder(),
        onPressed: () {
          // todo: implement the required functions
        },
        child: const Icon(Icons.call, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _getPageByIndex(controller.currentIndex.value),
        ),
      ),
    );
  }

  Widget _getPageByIndex(int index) {
    final pages = [
      DashboardView(),
      SubjectsView(),
      DashboardView(), // This won't be used since index 2 triggers modal
      ProfileView(),
    ];
    
    // Ensure index is within bounds
    if (index >= 0 && index < pages.length) {
      return pages[index];
    }
    
    return DashboardView(); // Default fallback
  }
}
