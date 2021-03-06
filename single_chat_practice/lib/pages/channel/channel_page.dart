import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/channel_ctrl.dart';
import 'package:single_chat_practice/controllers/web_test_ctrl.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatelessWidget {
  ChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller;
    if (Get.find<PlatformService>().isWeb) {
      controller = Get.find<WebChannelController>(
          tag: Get.find<WebTestController>().currentChannelCid.value);
    } else {
      controller = Get.put(ChannelController);
    }

    return Scaffold(
      appBar: const ChannelHeader(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageListView(
                threadBuilder: (_, parent) => ThreadPage(parent: parent),
              ),
            ),
            MessageInput(
              onMessageSent: (message) async {
                await controller.sendCommand(message);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({Key? key, this.parent}) : super(key: key);

  final Message? parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(parent: parent!),
      body: Column(
        children: [
          Expanded(
            child: MessageListView(
              parentMessage: parent,
            ),
          ),
          MessageInput(
            parentMessage: parent,
          ),
        ],
      ),
    );
  }
}
