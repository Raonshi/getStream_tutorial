import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/pages/home_page.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:single_chat_practice/widgets/web/login_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Get.find<PlatformService>().isWeb
        ? buildToWeb(context)
        : buildToMobile(context);
  }

  // Mobile UI build
  Widget buildToMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: !controller.isLogin.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

  // Web UI build
  Widget buildToWeb(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 800) {
          return LoginInputWidget();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1280) {
          return const Center(child: Text('Width is 1280'));
        } else {
          return const Center(child: Text('Width is max'));
        }
      },
    );
  }
}
