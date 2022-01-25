import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

class WebTestController extends GetxController {
  final channelList = <Channel>[].obs;

  Future<void> createChannel(User user, BuildContext context) async {
    var client = Get.find<StreamChatService>().client.value;
    var currentUser = client.state.currentUser;

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
          lgr.Logger().d(error);
        });

    channelList.add(channel);
  }

  Channel findMyChannel() {
    late Channel channel;
    var client = Get.find<StreamChatService>().client.value;

    for (int i = 0; i < channelList.length; i++) {
      bool isDone = false;
      final memebers = channelList[i].queryMembers().then((value) {
        for (int j = 0; j < value.members.length; j++) {
          if (value.members[j].userId == client.state.currentUser?.id) {
            channel = channelList[i];
            isDone = true;
            break;
          }
        }
      });
      if (isDone) break;
    }
    return channel;
  }
}
