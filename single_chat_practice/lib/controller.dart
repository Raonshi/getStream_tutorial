import 'dart:convert';

import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:http/http.dart' as http;

class Controller extends GetxService {
  final client = StreamChatClient('b67pax5b2wdq').obs;
  final channelList = [].obs;
  final userList = [].obs;

  final token = ''.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    initUserList();

    await client.value.connectUser(
      userList[0],
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c',
    );
  }

  // 유저 리스트 생성
  void initUserList() {
    for (int i = 0; i < 10; i++) {
      final User user = User(
        id: 'test_$i',
        name: 'tester_$i',
      );
      userList.add(user);
    }
  }

  //채널 생성 및 리스트 추가
  void createChannel(String type, String id) {
    Channel channel = client.value.channel('type', id: id);
    channelList.add(channel);
  }

  //채널 탐색
  dynamic findChannel(String id) {
    for (int i = 0; i < channelList.length; i++) {
      Channel channel = channelList[i];
      if (channel.id == id) {
        return channel;
      }
    }
  }
}
