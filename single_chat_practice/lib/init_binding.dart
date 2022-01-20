import 'package:get/get.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:logger/logger.dart';

//maybe doesn't work
class InitBinding {
  void initBind() {
    Logger().d("Init Controller and Service");
    //Service module init
    Get.put(FirebaseService());
    Get.put(StreamChatService());
    Get.put(NotificationService());
  }
}
