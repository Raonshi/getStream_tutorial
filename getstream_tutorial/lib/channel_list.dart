import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel.dart';

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ChannelBloc : 페이징 위젯
      body: ChannelsBloc(
        //채널 리스트를 구현하는 위젯
        child: ChannelListView(
          filter: Filter.in_(
            'members',
            [StreamChat.of(context).currentUser!.id],
          ),
          channelPreviewBuilder: _channelPreviewBuilder,
          //정렬 기준 -> 최근 메시지 기준
          sort: [SortOption('last_message_at')],
          //채널 개수 제한은 20개
          limit: 20,
          //채널을 클릭했을 때 나타나는 페이지
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }

  //커스텀 채널의 프리뷰(채팅방 목록 아이템)을 구현한다.
  Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
    //마지막 메시지를 찾는다.
    //채널 내 메시지 목록을 reverse한다.
    //첫 번째 값이 삭제되지 않았다면 lastMessage = message이다.
    final lastMessage = channel.state?.messages.reversed.firstWhere(
      (message) => !message.isDeleted,
    );

    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;

    final theme = StreamChatTheme.of(context);

    return ListTile(
      onTap: () {
        //Get.toNamed('/channel', arguments: channel);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: ChannelPage(),
            ),
          ),
        );
      },
      leading: ChannelAvatar(
        channel: channel,
      ),
      title: ChannelName(
        textStyle: theme.channelPreviewTheme.titleStyle!.copyWith(
          color: theme.colorTheme.textHighEmphasis.withOpacity(opacity),
        ),
      ),
      subtitle: Text(subtitle),
      trailing: channel.state!.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state!.unreadCount.toString()),
            )
          : const SizedBox(),
    );
  }
}
