import 'package:flutter/material.dart';
import 'package:get/get.dart';

//a tiny controller -> for page changing
class HomeController extends GetxService {
  final appBarText = ''.obs;
  final pageSelected = 0.obs;
  final pageController = PageController(initialPage: 0).obs;

  //page change function
  void pageChange(int index) {
    pageController.value.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );

    switch (index) {
      case 0:
        appBarText.value = 'Friends List';
        break;
      case 1:
        appBarText.value = 'Chat List';
        break;
      case 2:
        appBarText.value = 'Setting';
        break;
    }

    pageSelected.value = index;
  }
}
