import 'package:get/get.dart';
import 'package:ed_tech/app/modules/home/views/more.view.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt previousIndex = 0.obs; // Track the previous tab

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

  void changeTab(int index) {
    if (index == 2) {
      // If "More" tab is selected, show modal and keep current tab
      MoreView.showMoreOptions();
    } else {
      // Store the previous index and update current
      previousIndex.value = currentIndex.value;
      currentIndex.value = index;
    }
  }
}
