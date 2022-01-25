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

    await client.queryUsers(
      filter: Filter.and([
        //나를 제외한 모든 유저 표시
        Filter.notEqual('id', StreamChat.of(context).currentUser!.id),
      ]),
      sort: const [SortOption('last_message_at')],
    ).then((value) {
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
}
