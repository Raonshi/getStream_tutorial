import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChannelsBloc(
        child: ChannelListView(
          filter: Filter.in_(
              'members', [Get.find<LoginController>().authUser.value.id]),
          sort: const [SortOption('last_message_at')],
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
