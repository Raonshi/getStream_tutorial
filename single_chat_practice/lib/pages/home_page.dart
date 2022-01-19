import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/home_ctrl.dart';
import 'package:single_chat_practice/pages/chat_list_page.dart';
import 'package:single_chat_practice/pages/chat_select_page.dart';
import 'package:single_chat_practice/pages/setting_page.dart';
import 'package:single_chat_practice/pages/user_list_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(Controller());
  List<Widget> page = [UsersListPage(), const ChatListPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Chat App"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Obx(
              () => SafeArea(
                child: page[controller.pageSelected.value],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () => controller.pageChange(0),
                  child: const Text("Friends"),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => controller.pageChange(1),
                  child: const Text("Chat"),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => controller.pageChange(2),
                  child: const Text("Settings"),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
      //Floating Action Button : Create Chat
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: const Icon(Icons.add_rounded),
        onPressed: () => Get.to(() => ChatSelectPage()),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
