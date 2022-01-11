import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/chat_select_ctrl.dart';
import 'package:single_chat_practice/pages/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatSelectPage extends StatelessWidget {
  ChatSelectPage({Key? key}) : super(key: key);
  final controller = Get.put(ChatSelectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select User"),
      ),
      body: SafeArea(
        child: UsersBloc(
          child: UserListView(
            userWidget: ChannelPage(),
          ),
        ),
      ),
    );
  }
}