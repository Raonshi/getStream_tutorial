import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/init_binding.dart';
import 'package:single_chat_practice/pages/home_page.dart';
import 'package:single_chat_practice/pages/login_page.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitBinding().initBind();
  await Get.find<FirebaseService>().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final notificationService = Get.find<NotificationService>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(
        () {
          if (Get.find<PlatformService>().isWeb) {
            return loginController.isLogin.value
                ? HomePage()
                : const Center(child: CircularProgressIndicator());
          } else {
            return loginController.isLogin.value ? HomePage() : LoginPage();
          }
        },
      ),
      builder: (context, child) => StreamChat(
        child: child,
        client: loginController.streamChatService.client.value,
        onBackgroundEventReceived: notificationService.backgroundNotification,
      ),
    );
  }
}
