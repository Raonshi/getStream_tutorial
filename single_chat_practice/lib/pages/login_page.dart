import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: !controller.isLogin.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(),
                _buildLoginInputWidget('ID'),
                const Divider(),
                _buildLoginInputWidget('Name'),
                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    await controller.register();
                    if (controller.isLogin.value) {
                      Get.off(HomePage());
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            )
          : HomePage(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildLoginInputWidget(String label) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.authUser.value.id = value;
              },
            ),
          ),
        ),
      ],
    );
  }
}
