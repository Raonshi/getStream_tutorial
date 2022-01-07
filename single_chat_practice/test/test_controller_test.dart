import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxString _str = ''.obs;
  set setStr(value) => _str.value = value;

  bool stringChanger() {
    if (_str.isEmpty) {
      return false;
    }

    String str = _str.value;
    String tmp = str.toLowerCase();

    return true;
  }
}

void main() {
  test('''GetX Unit Test''', () {
    bool result = false;

    /* Input code under this line */

    final controller = Get.put(Controller());
    controller.setStr = 'ASDASKkasdjalsASdkDd';
    controller.stringChanger();

    expect(result, true);
  });
}
