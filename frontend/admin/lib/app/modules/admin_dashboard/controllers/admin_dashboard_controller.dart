import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  /// ---------------- OBSERVABLES ----------------
  
  /// Sidebar selected index
  final selectedIndex = 0.obs;

  /// Search query text
  final searchQuery = ''.obs;

  /// List of new joiners (name + status)
  final newJoiners = <Map<String, dynamic>>[
    {"name": "Ethan Carter", "status": true},
    {"name": "Sophia Bent", "status": true},
    {"name": "Liam Harper", "status": false},
    {"name": "Olivia Reed", "status": true},
    {"name": "Noah Foster", "status": true},
    {"name": "Ava Morgan", "status": false},
  ].obs;

  /// Number of students online (for Peak Time Card)
  final studentsOnline = 85.obs;

  /// ---------------- METHODS ----------------

  /// Update sidebar selection
  void selectMenu(int index) {
    selectedIndex.value = index;
    // Add navigation logic here if needed
    print('Menu selected: $index');
  }

  /// Handle logout action
  void logout() {
    // Add your logout logic here (e.g., clear session, navigate to login)
    print('User logged out');
  }

  /// Handle search input changes
  void updateSearch(String query) {
    searchQuery.value = query;
    print('Search query updated: $query');
  }

  /// Optionally add a new user to the joiners list
  void addNewJoiner(String name, bool isOnline) {
    newJoiners.add({"name": name, "status": isOnline});
  }

  /// Optionally update students online count (for real-time dashboard)
  void updateStudentsOnline(int count) {
    studentsOnline.value = count;
  }

  @override
  void onInit() {
    super.onInit();
    // You can initialize data from API here
    print('AdminDashboardController initialized');
  }
}