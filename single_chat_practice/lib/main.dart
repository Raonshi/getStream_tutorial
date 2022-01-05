import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'controller.dart';
import 'user_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final controller = Get.put(
    Controller(),
    tag: 'controller',
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return StreamChat(
          client: controller.client.value,
          child: child,
        );
      },
      home: UserListPage(),
    );
  }
}
