import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  //StreamChatClient 인스턴스 생성
  final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO);

  //StreamChatClient에 User객체 연결
  client.connectUser(
    User(id: 'tutorial-flutter'),
    '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c''',
  );

  //앱 실행 => 실행 시 StreamChatClient 인스턴스를 넘겨준다.
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    //UI 테마 지정
    final defaultTheme = StreamChatThemeData.fromTheme(
      ThemeData(primarySwatch: Colors.amber),
    );

    final customTheme = defaultTheme.merge(
      StreamChatThemeData(
        channelPreviewTheme: ChannelPreviewThemeData(
          avatarTheme: AvatarThemeData(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        otherMessageTheme: MessageThemeData(
          messageBackgroundColor: defaultTheme.colorTheme.textHighEmphasis,
          messageTextStyle: TextStyle(
            color: defaultTheme.colorTheme.barsBg,
          ),
          avatarTheme: AvatarThemeData(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

    //StreamChat위젯으로 앱을 실행한다.
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
        streamChatThemeData: customTheme,
      ),
      //처음 실행되는 홈 화면은 ChannelListPage
      home: const ChannelListPage(),
    );
  }
}

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
          channelWidget: const ChannelPage(),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const ChannelPage(),
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

class ChannelPage extends StatelessWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              messageBuilder: _messageBuilder,
              /*
              threadBuilder: (_, parentMessage) => ThreadPage(
                parent: parentMessage,
              ),
              */
            ),
          ),
          const MessageInput(),
        ],
      ),
    );
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    MessageWidget defaultMessageWidget,
  ) {
    final message = details.message;
    final isCurrentUser =
        StreamChat.of(context).currentUser!.id == message.user!.id;
    final textAlign = isCurrentUser ? TextAlign.right : TextAlign.left;
    final color = isCurrentUser ? Colors.blueGrey : Colors.blue;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: ListTile(
          title: Text(
            message.text!,
            textAlign: textAlign,
          ),
          subtitle: Text(
            message.user!.name,
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({
    Key? key,
    this.parent,
  }) : super(key: key);

  final Message? parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(
        parent: parent!,
      ),
      body: Column(
        children: <Widget>[
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
