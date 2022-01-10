import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/test_controller.dart';
import 'package:single_chat_practice/pages/login_page.dart';
import 'package:single_chat_practice/pages/user_list_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  //final controller = Get.put(MainController());
  final controller = Get.put(TestController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(
        () => controller.isLogin.value ? UsersListPage() : const LoginPage(),
      ),
      builder: (context, child) => StreamChat(
        child: child,
        client: controller.client.value,
      ),
    );
  }
}
