import 'package:flutter/material.dart';
import 'package:single_chat_practice/chat_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:get/get.dart';

import 'controller.dart';

class UserListPage extends StatelessWidget {
  UserListPage({Key? key}) : super(key: key);
  final controller = Get.find<Controller>(tag: 'controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        centerTitle: true,
      ),
      body: UsersBloc(
        child: UserListView(
          limit: 20,
          userItemBuilder: (context, user, isSelected) {
            return ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text(user.name),
              onTap: () {
                Get.defaultDialog(
                  title: user.name,
                  onCancel: () {},
                  onConfirm: () {
                    String id = 'flutterdevs';
                    controller.createChannel('messaging', id);
                    Get.to(() => ChatPage(channelID: id));
                  },
                );
              },
              onLongPress: () {
                Get.defaultDialog(
                  title: user.name,
                  content: Text(user.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
