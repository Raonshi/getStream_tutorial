import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/init_binding.dart';
import 'package:single_chat_practice/pages/home_page.dart';
import 'package:single_chat_practice/pages/login_page.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //calling GetxController initializing method in main() is much better
  //than calling in GetMaterialApp's initBinding parameter.
  //because if you can not control widget state,
  //GetMaterialApp will be  call initBinding when you didn't recognize.
  InitBinding().initBind();
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
        () => loginController.isLogin.value ? HomePage() : LoginPage(),
      ),
      builder: (context, child) => StreamChat(
        child: child,
        client: loginController.streamChatService.client.value,
        onBackgroundEventReceived: notificationService.backgroundNotification,
      ),
    );
  }
}
