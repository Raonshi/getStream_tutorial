import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/main_controller.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('LOGIN'),
          subtitle: controller.isLogin.value
              ? const Text("Logined")
              : const Text("Login now"),
          onTap: () async {
            await controller.login();
          },
        ),
        const Divider(),
      ],
    );
  }
}
