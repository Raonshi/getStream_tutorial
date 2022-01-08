import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/test_controller.dart';

void main() {
  test('''GetX Unit Test''', () async {
    bool result = false;

    /* Input code under this line */

    final controller = Get.put(TestController());
    result = await controller.login();

    expect(result, true);
  });
}
