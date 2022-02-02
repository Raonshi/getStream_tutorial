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
        _buildTopBarButton(icon: Icons.people, onPressed: () {}),
        const Spacer(),
        _buildTopBarButton(icon: Icons.list_alt, onPressed: () {}),
        const Spacer(),
        _buildTopBarButton(icon: Icons.notifications, onPressed: () {}),
        const Spacer(),
        _buildTopBarButton(
          icon: Icons.login,
          onPressed: () {
            final loginController = Get.find<LoginController>();
            loginController.isLogin.value
                ? loginController.logout()
                : Get.defaultDialog(title: 'Log in');
          },
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildTopBarButton(
      {required IconData icon, required Function() onPressed}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
