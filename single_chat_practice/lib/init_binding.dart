import 'package:get/get.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(FirebaseService());
    Get.put(NotificationService());
    Get.put(StreamChatService());
  }
}
