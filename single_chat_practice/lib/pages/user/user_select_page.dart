import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/pages/channel/channel_page.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserSelectPage extends StatelessWidget {
  UserSelectPage({Key? key}) : super(key: key);
  final streamCtrl = Get.find<StreamChatService>();
  final loginCtrl = Get.find<LoginController>();

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
                Filter.notEqual('id', loginCtrl.authUser.value.id),
              ]),
              sort: const [SortOption('last_message_at')],
              selectedUsers: streamCtrl.selectedUser.value,
              onUserTap: (user, _) {
                bool isAdd = streamCtrl.selectedUser.add(user);
                if (!isAdd) {
                  streamCtrl.selectedUser.remove(user);
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
          Channel channel = await streamCtrl.createChattingRoom();
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
