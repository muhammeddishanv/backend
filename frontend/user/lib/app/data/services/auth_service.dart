import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/*
  This service handles the authentication state of the user.
  It keeps track of whether the user is logged in or not.

  created by : Muhammed Shabeer OP
  date : 2025-08-10
  updated date : 2025-08-10
 */

class AuthService extends GetxService {
  final box = GetStorage(); // Initialize GetStorage
  final RxBool isLoggedIn = false.obs; // Track login state

  /// Initialize the AuthService
  Future<AuthService> init() async {
    await GetStorage.init();
    isLoggedIn.value = box.read('isLoggedIn') ?? false;
    return this;
  }

  // Call this after successful login
  void login() {
    box.write('isLoggedIn', true);
    isLoggedIn.value = true;
  }

  // Call this after successful logout
  void logout() {
    box.write('isLoggedIn', false);
    isLoggedIn.value = false;
  }

  void generateOTP() {
    // TODO: Implement real OTP generation
  }

  Future<bool> verifyOTP(String code) async {
    // TODO: Implement real OTP verification
    return true;
  }
}
