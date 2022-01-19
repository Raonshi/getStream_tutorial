import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/home_ctrl.dart';
import 'package:single_chat_practice/pages/chat_list_page.dart';
import 'package:single_chat_practice/pages/chat_select_page.dart';
import 'package:single_chat_practice/pages/setting_page.dart';
import 'package:single_chat_practice/pages/user_list_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.appBarText.value))),
      body: SafeArea(
        child: PageView(
          controller: controller.pageController.value,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            UsersListPage(),
            ChatListPage(),
            SettingPage(),
          ],
        ),
      ),

      //Bottom Navigator bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.pageSelected.value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'Chatting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (value) => controller.pageChange(value),
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
