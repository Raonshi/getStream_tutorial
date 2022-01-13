import 'package:get/get.dart';

class Controller extends GetxService {
  RxInt pageSelected = 0.obs;
  void pageChange(int index) {
    pageSelected.value = index;
  }
}
