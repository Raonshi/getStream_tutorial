import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/test_controller.dart';
import 'package:single_chat_practice/pages/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UsersListPage extends StatelessWidget {
  final controller = Get.put(TestController());

  UsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchUsers(context);

    return Scaffold(
      //Top
      appBar: AppBar(
        title: const Text("Friends List"),
      ),

      //Body
      body: Obx(
        () => SafeArea(
          child: controller.loadingData.value
              ? const Center(child: CircularProgressIndicator())
              : controller.userList.isEmpty
                  ? const Center(child: Text('Could not fetch users'))
                  : UsersBloc(
                      child: UserListView(
                        onUserTap: (user, _) async {
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
                        userWidget: ChannelPage(),
                      ),
                    ),
        ),
      ),
    );
  }
}
