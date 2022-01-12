import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Controller extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;
  final isLogin = false.obs;
  final loadingData = true.obs;

  RxList userList = [].obs;
  RxInt pageSelected = 0.obs;

  Future<Channel> navigateToChannel(int index, BuildContext context) async {
    var client = StreamChat.of(context).client;
    var currentUser = StreamChat.of(context).currentUser;

    late Channel channel;

    await client
        .channel('messaging', extraData: {
          'members': [currentUser!.id, userList[index].id]
        })
        .create()
        .then((response) {
          channel = Channel.fromState(client, response);
          channel.watch();
        })
        .catchError((error) {
          print(error);
        });

    return channel;
  }

  Future<Channel> createChannel(User user, BuildContext context) async {
    var client = StreamChat.of(context).client;
    var currentUser = StreamChat.of(context).currentUser;

    late Channel channel;

    await client
        .channel('messaging', extraData: {
          'members': [currentUser!.id, user.id]
        })
        .create()
        .then((response) {
          channel = Channel.fromState(client, response);
          channel.watch();
        })
        .catchError((error) {
          print(error);
        });

    return channel;
  }

  void pageChange(int index) {
    pageSelected.value = index;
  }
}
