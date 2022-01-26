import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/channel_ctrl.dart';
import 'package:single_chat_practice/controllers/home_ctrl.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/controllers/web_test_ctrl.dart';
import 'package:single_chat_practice/pages/channel/channel_list_page.dart';
import 'package:single_chat_practice/pages/channel/channel_page.dart';
import 'package:single_chat_practice/pages/setting_page.dart';
import 'package:single_chat_practice/pages/user/user_list_page.dart';
import 'package:single_chat_practice/pages/user/user_select_page.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:single_chat_practice/widgets/web/channel_list_widget.dart';
import 'package:single_chat_practice/widgets/web/top_bar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());
  final webController = Get.put(WebTestController());

  @override
  Widget build(BuildContext context) {
    return Get.find<PlatformService>().isWeb
        ? buildToWeb(context)
        : buildToMobile(context);
  }

  Widget buildToMobile(BuildContext context) {
    return Scaffold(
      //Header
      appBar: AppBar(title: Obx(() => Text(homeController.appBarText.value))),

      //Body
      body: SafeArea(
        child: PageView(
          controller: homeController.pageController.value,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            UserListPage(),
            const ChannelListPage(),
            SettingPage(),
          ],
        ),
      ),

      //Bottom Navigator bar
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: homeController.pageSelected.value,
          selectedItemColor: Colors.blueAccent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_rounded),
              label: 'Chatting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (value) => homeController.pageChange(value),
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

  Widget buildToWeb(BuildContext context) {
    webController.initChannelList();

    return Scaffold(
      //Header
      appBar: AppBar(title: TopBar()),

      //Body
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ChannelListWidget(),
            ),
            Expanded(
              flex: 4,
              child: Obx(
                () {
                  final channelController = Get.find<ChannelController>(
                      tag: webController.currentChannelCid.value);
                  return StreamChannel(
                    channel: channelController.channel,
                    child: ChannelPage(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
