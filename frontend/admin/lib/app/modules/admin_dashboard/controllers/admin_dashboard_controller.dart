import 'package:get/get.dart';

// Controller for the Admin Dashboard. Provides observable application state
// used by the dashboard widgets (sidebar selection, search input, lists,
// and simple metrics). Extend these methods to hook up real API calls and
// navigation.
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

  /// Update sidebar selection and optionally trigger navigation.
  void selectMenu(int index) {
    selectedIndex.value = index;
    // Add navigation logic here if needed
    print('Menu selected: $index');
  }

  /// Handle logout action (placeholder). Replace with real session
  /// clearing and navigation to sign-in screen.
  void logout() {
    print('User logged out');
  }

  /// Handle search input changes
  void updateSearch(String query) {
    searchQuery.value = query;
    print('Search query updated: $query');
  }

  /// Add a new joiner to the sample list
  void addNewJoiner(String name, bool isOnline) {
    newJoiners.add({"name": name, "status": isOnline});
  }

  /// Update the students online count
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
