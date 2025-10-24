import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/core/utils/extensions/input_decorations.dart';
import 'package:ed_tech/app/core/utils/functions/form_validation_helper.dart';
import 'package:ed_tech/app/core/utils/helpers/toast_helper.dart';
import 'package:ed_tech/app/global_widgets/custom_app_bar.dart';

import 'auth.controller.dart';

/*
  This is the view for the authentication module.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Muhammed Shabeer OP
  date : 2025-08-07
  updated date : 2025-08-07
*/

/*
  Additional notes:
  - This file handles the Sign In UI and form validation wiring. Controller
    contains business logic for signin flow and toast notifications.
  - Non-functional header added 2025-10-23 to improve discoverability during
    onboarding and code reviews.
*/

class AuthView extends GetResponsiveView<AuthController> {
  //form key
  static final formKey = GlobalKey<FormState>();

  AuthView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => _buildLogin();

  @override
  Widget tablet() => Icon(Icons.tablet, size: 75);

  @override
  Widget desktop() => Icon(Icons.desktop_mac, size: 75);

  Widget _buildLogin() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Get.size;
        final height = size.height;
        final width = size.width;
        final isSmallHeight = height < 700; // very small devices
        final baseTextScale = Get.textScaleFactor;

        // Dynamic sizing helpers
        double v(double h) => height * h; // fraction of screen height
        double sp(double value) => min(value, value * (height / 800) * 1.05);
        double topBarHeight = min(250, height * 0.30);

        EdgeInsets horizontalPadding = EdgeInsets.symmetric(
          horizontal: max(16, width * 0.06),
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Get.theme.colorScheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(topBarHeight),
                child: CustomTopBar(
                  child: Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: min(120, width * 0.30),
                      color: Colors.white.withAlpha(40),
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: horizontalPadding.add(EdgeInsets.only(bottom: 24)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight -
                          topBarHeight -
                          MediaQuery.of(context).padding.vertical,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: v(isSmallHeight ? 0.02 : 0.05)),
                          Center(
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: sp(41 * baseTextScale).clamp(28, 44),
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: v(0.008)),
                          Center(
                            child: SizedBox(
                              width: min(width * 0.85, 500),
                              child: Text(
                                "Let's experience the joy of smart learning",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: sp(
                                    16 * baseTextScale,
                                  ).clamp(13, 20),
                                  color: Get.theme.colorScheme.onSurface
                                      .withAlpha(85),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: v(isSmallHeight ? 0.03 : 0.06)),

                          // Form
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone",
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.onSurface,
                                    fontSize: sp(
                                      14 * baseTextScale,
                                    ).clamp(12, 18),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  // canRequestFocus: false,
                                  controller: controller.phoneController,
                                  validator: FormValidationHelper.validatePhone,
                                  decoration: inputDecoration(
                                    "Phone",
                                    hint: "XXXXXXXXXX",
                                  ),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(height: 17),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.onSurface,
                                    fontSize: sp(
                                      14 * baseTextScale,
                                    ).clamp(12, 18),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Obx(
                                  () => TextFormField(
                                    // canRequestFocus: false,
                                    controller: controller.passwordController,
                                    validator:
                                        FormValidationHelper.validatePassword,
                                    decoration:
                                        inputDecoration(
                                          "Password",
                                          hint: "********",
                                        ).copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.isVisible.value
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                              color: Get.theme.hintColor,
                                            ),
                                            onPressed: () {
                                              controller.isVisible.value =
                                                  !controller.isVisible.value;
                                            },
                                          ),
                                        ),
                                    obscureText: !controller.isVisible.value,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                                SizedBox(height: 12),
                                // terms and conditions clickable Terms & Policy text
                                Center(
                                  child: Obx(
                                    () => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: controller.checked.value,
                                          onChanged: (value) {
                                            controller.checked.value =
                                                value ?? false;
                                          },
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Text(
                                          "By signing in, you agree to our ",
                                          style: TextStyle(
                                            fontSize: sp(
                                              13 * baseTextScale,
                                            ).clamp(11, 16),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //todo : navigate to terms and policy website
                                          },
                                          child: Text(
                                            "Terms & Policy",
                                            style: TextStyle(
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              fontSize: sp(
                                                13 * baseTextScale,
                                              ).clamp(11, 16),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: v(0.02)),
                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                          double.infinity,
                                          max(46, v(0.055)),
                                        ),
                                        backgroundColor:
                                            Get.theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),

                                      // !important : signin function
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () {
                                              controller.isLoading.value = true;

                                              if ((formKey.currentState
                                                      ?.validate() ??
                                                  false)) {
                                                if (controller.checked.value) {
                                                  FocusScope.of(
                                                    context,
                                                  ).unfocus(); // hide keyboard
                                                  controller.signin();
                                                } else {
                                                  controller.isLoading.value =
                                                      false;
                                                  Get.find<ToastHelper>().showError(
                                                    'Please accept terms and conditions',
                                                  );
                                                }
                                              } else {
                                                controller.isLoading.value =
                                                    false;
                                              }
                                            },
                                      child: controller.isLoading.value
                                          ? SizedBox(
                                              height: 24,
                                              width: 24,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    color: Get
                                                        .theme
                                                        .colorScheme
                                                        .onPrimary,
                                                    fontSize: sp(
                                                      18 * baseTextScale,
                                                    ).clamp(15, 22),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Get
                                                      .theme
                                                      .colorScheme
                                                      .onPrimary,
                                                  size: sp(
                                                    15 * baseTextScale,
                                                  ).clamp(12, 18),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: v(0.035)),
                          // social login placeholder
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(max(8, width * 0.02)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: Get.theme.colorScheme.primary,
                                  width: 1,
                                ),
                              ),
                              onPressed: () {
                                //todo : navigate to whatsapp link
                              },
                              child: Icon(
                                Icons
                                    .wallet, //todo : replace with whatsapp icon
                                size: sp(30).clamp(22, 36),
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: v(0.02)),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                //todo : navigate to forgot password page || bottom sheet with reset link (email | phone)
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.onSurface,
                                  fontSize: sp(
                                    16 * baseTextScale,
                                  ).clamp(13, 20),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // Fill remaining space if tall screen so button area pins reasonably
                          if (!isSmallHeight) Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ), // end SafeArea
            ), // end AnnotatedRegion
          ),
        );
      },
    );
  }
}
