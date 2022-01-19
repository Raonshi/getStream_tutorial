import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/user_list_ctrl.dart'
    as userCtrl;
import 'package:single_chat_practice/pages/channel/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserListPage extends StatelessWidget {
  final controller = Get.put(userCtrl.UserListController());

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
                      onUserTap: (user, _) => Get.defaultDialog(
                        title: user.name,
                        content: const Text("Start Chat"),
                        onCancel: () {},
                        onConfirm: () async {
                          Channel channel =
                              await controller.createChannel(user, context);
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
