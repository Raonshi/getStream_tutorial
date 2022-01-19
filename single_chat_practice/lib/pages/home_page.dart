import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/home_ctrl.dart';
import 'package:single_chat_practice/pages/channel/channel_list_page.dart';
import 'package:single_chat_practice/pages/setting_page.dart';
import 'package:single_chat_practice/pages/user/user_list_page.dart';
import 'package:single_chat_practice/pages/user/user_select_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Header
      appBar: AppBar(title: Obx(() => Text(controller.appBarText.value))),

      //Body
      body: SafeArea(
        child: PageView(
          controller: controller.pageController.value,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            UserListPage(),
            ChannelListPage(),
            SettingPage(),
          ],
        ),
      ),

      //Bottom Navigator bar
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.pageSelected.value,
          selectedItemColor: Colors.blueAccent,
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
      ),

      //Floating Action Button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => Get.to(() => UserSelectPage()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
