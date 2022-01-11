import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/main_controller.dart';

class ChatSelectController extends GetxController {
  RxList userList = [].obs;

  @override
  void onInit() {
    final mainController = Get.find<Controller>();
    userList = mainController.userList;
    super.onInit();
  }
}
