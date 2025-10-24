// View: Sign-in Screen (Admin)
// Purpose: Authentication UI for admin users. Keeps form and navigation only; authentication logic lives in controllers/services.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart' show Routes;

class SigninScreenSigninView extends GetResponsiveView {
  SigninScreenSigninView({super.key}) : super(alwaysUseBuilder: false);

  final RxString email = "".obs;
  final RxString password = "".obs;

  @override
  Widget phone() => const SizedBox(); // Not needed
  @override
  Widget tablet() => const SizedBox(); // Not needed

  @override
  Widget desktop() {
    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.surface,
      body: Center(
        child: Container(
          width: 700,
          height: 450,
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(Get.context!).shadowColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Left Section (Welcome)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(
                            Get.context!,
                          ).colorScheme.surface,
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 40,
                            color: Theme.of(Get.context!).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Welcome ",
                          style: TextStyle(
                            color: Theme.of(Get.context!).colorScheme.onPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign in to continue\nto your dashboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(
                              Get.context!,
                            ).colorScheme.onPrimary.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Right Section (Form)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// Email Field
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => email.value = val,
                      ),
                      const SizedBox(height: 20),

                      /// Password Field
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => password.value = val,
                      ),
                      const SizedBox(height: 30),

                      /// Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle login
                            if (email.value.isNotEmpty &&
                                password.value.isNotEmpty) {
                              if (email.value == "admin@gmail.com" &&
                                  password.value == "admin123") {
                                Get.toNamed(Routes.ADMIN_DASHBOARD);
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Invalid email and password",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } else {
                              Get.snackbar(
                                "Error",
                                "Please enter credentials",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Sign In"),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Links
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
