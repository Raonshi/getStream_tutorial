import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/home_ctrl.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/pages/channel/channel_list_page.dart';
import 'package:single_chat_practice/pages/channel/channel_page.dart';
import 'package:single_chat_practice/pages/setting_page.dart';
import 'package:single_chat_practice/pages/user/user_list_page.dart';
import 'package:single_chat_practice/pages/user/user_select_page.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:single_chat_practice/controllers/user_list_ctrl.dart' as user;

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());
  final userController = Get.put(user.UserListController());

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
    late Channel channel;
    return Scaffold(
      //Header
      appBar: AppBar(title: Obx(() => Text(homeController.appBarText.value))),

      //Body
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: UsersBloc(
                child: UserListView(
                  filter: Filter.and(
                    [
                      //나를 제외한 모든 유저 표시
                      Filter.notEqual(
                          'id', Get.find<LoginController>().authUser.value.id),
                    ],
                  ),
                  sort: const [SortOption('last_message_at')],
                  onUserTap: (user, _) => Get.defaultDialog(
                    title: user.name,
                    content: const Text("Start Chat"),
                    onCancel: () {},
                    onConfirm: () async {
                      channel =
                          await userController.createChannel(user, context);
                    },
                  ),
                  userWidget: ChannelPage(),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: StreamChannel(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: ChannelPage(),
                ),
                channel: channel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
