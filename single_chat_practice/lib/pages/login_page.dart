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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'ID',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          controller.authUser.value.id = value;
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          controller.authUser.value.name = value;
                        },
                      ),
                    ),
                  ],
                ),
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
}
