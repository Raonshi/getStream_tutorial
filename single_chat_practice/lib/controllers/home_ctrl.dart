import 'package:get/get.dart';

//a tiny controller -> for page changing
class Controller extends GetxService {
  RxInt pageSelected = 0.obs;
  void pageChange(int index) {
    pageSelected.value = index;
  }
}
