import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/controllers/user_list_ctrl.dart'
    as user_ctrl;
import 'package:single_chat_practice/pages/channel/channel_page.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserListPage extends StatelessWidget {
  final controller = Get.put(user_ctrl.UserListController());
  UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchUsers(context);
    return Obx(
      () => SafeArea(
        child: controller.loadingData.value
            ? const Center(child: CircularProgressIndicator())
            : controller.userList.isEmpty
                ? const Center(child: Text('Could not fetch users'))
                : UsersBloc(
                    child: UserListView(
                      filter: Filter.and([
                        //나를 제외한 모든 유저 표시
                        Filter.notEqual('id',
                            Get.find<LoginController>().authUser.value.id),
                      ]),
                      sort: const [SortOption('last_message_at')],
                      onUserTap: (user, _) => Get.defaultDialog(
                        title: user.name,
                        content: const Text("Start Chat"),
                        onCancel: () {},
                        onConfirm: () async {
                          final streamCtrl = Get.find<StreamChatService>();
                          streamCtrl.selectedUser.add(user);
                          Channel channel =
                              await streamCtrl.createChannel(context);
                          Get.to(
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
                      userWidget: ChannelPage(),
                    ),
                  ),
      ),
    );
  }
}
