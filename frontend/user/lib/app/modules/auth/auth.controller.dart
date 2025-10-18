import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'package:ed_tech/app/core/utils/helpers/toast_helper.dart';
import 'package:ed_tech/app/data/services/auth_service.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

/*
  This controller handles the authentication logic for the app.
  It manages the user login processes.

  created by : Muhammed Shabeer OP
  date : 2025-08-10
  updated date : 2025-08-10
 */

class AuthController extends GetxController {
  RxBool checked = false.obs;
  RxBool isVisible = false.obs;
  RxBool isLoading = false.obs;
  RxString phone = ''.obs;
  RxString password = ''.obs;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void signin() {
    phone.value = phoneController.text.trim();
    password.value = passwordController.text.trim();

    // Simulate a login request
    Future.delayed(Duration(seconds: 2), () {
      // Here you would typically check the phone and password
      // todo : implement real authentication
      if (phone.value == "9876543210" && password.value == "password") {
        Get.find<AuthService>()
            .generateOTP(); //todo : implement real otp generation
        _showOTPBottomSheet();
        // ToastHelper.showSuccess('Login successful');
        // Get.offAllNamed('/home');
      } else {
        isLoading.value = false;
        Get.find<ToastHelper>().showError('Invalid phone number or password');
      }
    });
  }

  void _showOTPBottomSheet() {
    // using pinput for OTP input
    final theme = Get.theme;
    final otpController = TextEditingController();
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isComplete = otpController.text.length == 6;
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Verify OTP',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter the 6 digit code sent to your number',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),
                    Pinput(
                      controller: otpController,
                      length: 6,
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                      onCompleted: (_) => setState(() {}),
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isComplete
                            ? () async {
                                //! ---> OTP and User Verification <--- HERE
                                final code = otpController.text;
                                final isValid = await Get.find<AuthService>()
                                    .verifyOTP(code);
                                if (isValid) {
                                  Get.find<ToastHelper>().showSuccess(
                                    'OTP submitted: $code',
                                  );
                                  FocusScope.of(Get.context!).unfocus();
                                  Get.find<AuthService>().login();

                                  await Future.delayed(
                                    Duration(milliseconds: 500),
                                  );

                                  if (Get.find<AuthService>()
                                      .isLoggedIn
                                      .value) {
                                    isLoading.value = false;
                                    Get.offAllNamed(Routes.HOME);
                                  }
                                } else {
                                  isLoading.value = false;
                                  Get.find<ToastHelper>()
                                      .showError('Invalid OTP');
                                }
                              }
                            : null,
                        child: const Text('Continue'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.find<AuthService>().generateOTP();
                        Get.find<ToastHelper>().showInfo('OTP resent');
                      },
                      child: const Text('Resend code'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
