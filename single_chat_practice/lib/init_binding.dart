import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:logger/logger.dart';

class InitBinding extends GetxController {
  void createService() {
    //Service module init
    Get.put(PlatformService());
    Get.put(StreamChatService());
    Get.put(FirebaseService());
    Get.put(NotificationService());
    Get.put(LoginController());
    Logger().d("==== All Services Created! ====");
  }

  void initService() async {
    Get.find<PlatformService>().init();
    Get.find<StreamChatService>().init();
    await Get.find<FirebaseService>().init();
    Get.find<NotificationService>().init();
    Get.find<LoginController>().init();

    Logger().d("==== All Services Initialized ====");
  }
}
