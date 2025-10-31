import 'package:ed_tech/app/modules/on_boarding/views/category.view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'on_boarding.controller.dart';

class OnBoardingView extends GetResponsiveView<OnBoardingController> {
  OnBoardingView({super.key});

  @override
  Widget? phone() {
    return _buildOnBoardingContent();
  }

  @override
  Widget? tablet() {
    return _buildOnBoardingContent();
  }

  @override
  Widget? desktop() {
    return _buildOnBoardingContent();
  }

  Widget _buildOnBoardingContent() {
    return CategoryView();
  }
}
