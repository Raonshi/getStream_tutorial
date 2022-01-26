import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'api_service.dart';

class StreamChatService extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;
  final selectedUser = <User>{}.obs;
  final loadingData = true.obs;
  final userList = [].obs;

  //connect client
  Future<User> connect(AuthUser authUser) async {
    var body = json.encode({
      'userId': authUser.id,
      'name': authUser.name,
      'email': authUser.firebaseUser.email!
    });

    //request to server and response
    //dynamic data = await ApiService().requestToken(body);
    var data =
        await ApiService().request(type: 'post', action: 'token', body: body);
    var userToken = data['token'];

    //user infomation serialize
    User user = User(
      id: authUser.id,
      name: authUser.name,
      extraData: {'email': authUser.firebaseUser.email},
    );

    //connect client to stream server
    await client.value.connectUser(user, userToken).then((response) {
      return true;
    }).catchError((error) {
      return false;
    });

    //listen notification event
    client.value
        .on(EventType.messageNew, EventType.notificationMessageNew)
        .listen((event) async {
      Get.find<NotificationService>().showNotification(client.value, event);
    });

    return user;
  }

  //dispose
  Future<void> disconnect() async {
    await client.value.disconnectUser();
  }

  Future<Channel> createChannel(BuildContext context) async {
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
        });

    selectedUser.clear();
    return channel;
  }

  void fetchUsers(BuildContext context) async {
    loadingData.value = true;
    await client.value.queryUsers(
      filter: Filter.and([
        //나를 제외한 모든 유저 표시
        Filter.notEqual('id', StreamChat.of(context).currentUser!.id),
      ]),
      sort: const [SortOption('last_message_at')],
    ).then((value) {
      if (value.users.isNotEmpty) {
        userList.value = value.users.where((element) {
          return element.id != client.value.state.currentUser!.id;
        }).toList();
      }
      loadingData.value = false;
    }).catchError((error) {
      loadingData.value = false;
    });
  }
}
