import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'stream_chat_client.dart';
import 'routes.dart';
import 'channel_list.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = Get.put(
    StreamChatClientController(),
    tag: 'controller',
  );

  @override
  Widget build(BuildContext context) {
    final StreamChatClient client = controller.client.value;

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
    return GetMaterialApp(
      getPages: pages,
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
