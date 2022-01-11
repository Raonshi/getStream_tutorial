import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/main_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatSelectController extends GetxController {
  RxList userList = [].obs;
  RxSet<User> selectedUser = <User>{}.obs;

  @override
  void onInit() {
    final mainController = Get.find<Controller>();
    userList = mainController.userList;
    super.onInit();
  }

  Future<Channel> createChannel(BuildContext context) async {
    if (selectedUser.length == 1) {
      return Get.find<Controller>().createChannel(selectedUser.first, context);
    } else {
      var client = StreamChat.of(context).client;
      var currentUser = StreamChat.of(context).currentUser;

      late Channel channel;

      List<String> members = [];
      members.add(StreamChat.of(context).currentUser!.id);

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
            print(error);
          });

      return channel;
    }
  }
}
