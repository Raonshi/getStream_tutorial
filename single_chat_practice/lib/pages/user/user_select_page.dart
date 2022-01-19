import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/chat_select_ctrl.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/pages/channel/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserSelectPage extends StatelessWidget {
  UserSelectPage({Key? key}) : super(key: key);
  final controller = Get.put(UserSelectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select User"),
      ),
      body: Obx(
        () => SafeArea(
          child: UsersBloc(
            child: UserListView(
              filter: Filter.and([
                //나를 제외한 모든 유저 표시
                Filter.notEqual(
                    'id', Get.find<LoginController>().authUser.value.id),
              ]),
              sort: const [SortOption('last_message_at')],
              selectedUsers: controller.selectedUser.value,
              onUserTap: (user, _) {
                bool isAdd = controller.selectedUser.add(user);
                if (!isAdd) {
                  controller.selectedUser.remove(user);
                }
              },
              userWidget: ChannelPage(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.question_answer_rounded),
        onPressed: () async {
          Channel channel = await controller.createChannel(context);
          Get.off(
            () => StreamChannel(
              child: StreamChatTheme(
                data: StreamChatThemeData.light(),
                child: ChannelPage(),
              ),
              channel: channel,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
