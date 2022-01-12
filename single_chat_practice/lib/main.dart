import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/init_binding.dart';
import 'package:single_chat_practice/pages/home_page.dart';
import 'package:single_chat_practice/pages/login_page.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final streamController = Get.put(StreamChatService());
  final firebaseController = Get.put(FirebaseService());

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBinding(),
      title: 'Chat Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(
        () => firebaseController.isLogin.value ? HomePage() : LoginPage(),
      ),
      builder: (context, child) => StreamChat(
        child: child,
        client: streamController.client.value,
      ),
    );
  }
}
