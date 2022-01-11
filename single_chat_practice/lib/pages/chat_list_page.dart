import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/main_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({Key? key}) : super(key: key);

  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChannelsBloc(
        child: ChannelListView(
          onChannelTap: (channel, _) {
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
      ),
    );
  }
}
