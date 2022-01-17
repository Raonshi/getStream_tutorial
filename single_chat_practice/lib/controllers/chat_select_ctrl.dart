import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/user_list_ctrl.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

class ChatSelectController extends GetxController {
  //if you choose multi user
  RxSet<User> selectedUser = <User>{}.obs;

  //generate new channel
  Future<Channel> createChannel(BuildContext context) async {
    if (selectedUser.length == 1) {
      return Get.find<FriendListController>()
          .createChannel(selectedUser.first, context);
    } else {
      var client = Get.find<StreamChatService>().client.value;
      var currentUser = client.state.currentUser;

      late Channel channel;

      List<String> members = [];
      members.add(currentUser!.id);

      for (int i = 0; i < selectedUser.length; i++) {
        User user = selectedUser.elementAt(i);
        members.add(user.id);
      }

      await client
          .channel('messaging', extraData: {'members': members})
          .create()
          .then((response) {
            channel = Channel.fromState(client, response);
            channel.watch();
          })
          .catchError((error) {
            lgr.Logger().d(error);
          });

      return channel;
    }
  }
}
