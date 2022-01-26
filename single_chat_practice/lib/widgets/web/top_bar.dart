import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        IconButton(onPressed: () {}, icon: Icon(Icons.people)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.list_alt)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        const Spacer(),
        IconButton(
            onPressed: () {
              final loginController = Get.find<LoginController>();
              loginController.isLogin.value
                  ? loginController.logout()
                  : Get.defaultDialog(title: 'Log in');
            },
            icon: Icon(Icons.login)),
        const Spacer(flex: 2),
      ],
    );
  }
}
