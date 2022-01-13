import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

class FriendListController extends GetxController {
  RxBool loadingData = true.obs;
  RxList userList = [].obs;

  void fetchUsers(BuildContext context) async {
    final loginController = Get.find<LoginController>();
    loadingData.value = true;

    await StreamChat.of(context).client.queryUsers(
      filter: Filter.and([
        //나를 제외한 모든 유저 표시
        Filter.notEqual(
            'id', loginController.authUser.value.firebaseUser.email!),
      ]),
      sort: [const SortOption('last_message_at')],
    ).then((value) {
      if (value.users.length > 0) {
        userList.value = value.users.where((element) {
          return element.id != StreamChat.of(context).currentUser!.id;
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
          lgr.Logger().d(error);
        });

    return channel;
  }
}
