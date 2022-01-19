import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

class UserListController extends GetxController {
  RxBool loadingData = true.obs;
  RxList userList = [].obs;
  final loginController = Get.find<LoginController>();

  void fetchUsers(BuildContext context) async {
    final client = loginController.streamChatService.client.value;
    loadingData.value = true;

    await client.queryUsers(filter: const Filter.empty()).then((value) {
      if (value.users.isNotEmpty) {
        userList.value = value.users.where((element) {
          return element.id != client.state.currentUser!.id;
        }).toList();
      }
      lgr.Logger().d(userList);

      loadingData.value = false;
    }).catchError((error) {
      loadingData.value = false;
      lgr.Logger().d(error);
    });
  }

  Future<Channel> createChannel(User user, BuildContext context) async {
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

    return channel;
  }
}
