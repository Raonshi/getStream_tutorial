import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('LOGIN'),
          subtitle: loginController.isLogin.value
              ? const Text('log out')
              : const Text('log in'),
          onTap: () async {
            if (loginController.isLogin.value) {
              await loginController.logout();
            } else {
              await loginController.login();
            }
          },
        ),
        const Divider(),
      ],
    );
  }
}
