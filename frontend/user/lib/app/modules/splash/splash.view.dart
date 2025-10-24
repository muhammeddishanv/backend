import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'splash.controller.dart';

/*
  SplashView
  - Purpose: Lightweight splash screen shown while the app initializes.
  - Notes: Keeps logic minimal; controller decides navigation after init.
  - Header added 2025-10-23 (annotation only).
*/

class SplashView extends GetResponsiveView<SplashController> {
  SplashView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => _buildSplashContent();

  @override
  Widget tablet() => _buildSplashContent();

  @override
  Widget desktop() => _buildSplashContent();

  Widget _buildSplashContent() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cast_for_education, size: 75),
            Text(
              'EdTech',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
