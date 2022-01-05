import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    Key? key,
    required this.channelID,
  }) : super(key: key);

  final String channelID;
  final controller = Get.find<Controller>(tag: 'controller');

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: controller.findChannel(channelID),
      child: Scaffold(
        appBar: const ChannelHeader(),
        body: Column(
          children: const <Widget>[
            Expanded(
              child: MessageListView(),
            ),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
