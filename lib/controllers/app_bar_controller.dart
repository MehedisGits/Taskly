import 'package:get/get.dart';

class CustomAppBarController extends GetxController {
  // Observable to track if the search bar is active
  var isSearchActive = false.obs;

  // Methods to toggle search bar state
  void activateSearch() {
    isSearchActive.value = true;
  }

  void deactivateSearch() {
    isSearchActive.value = false;
  }
}
