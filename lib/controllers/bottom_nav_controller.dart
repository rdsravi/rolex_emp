import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs; // observable for selected index

  // Method to handle item tap
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
