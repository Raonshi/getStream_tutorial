import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class TestController extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;
  final isLogin = false.obs;
  final loadingData = true.obs;

  RxList userList = [].obs;

  @override
  void onInit() async {
    super.onInit();
    isLogin.value = await login();
  }

  Future<bool> login() async {
    const userID = 'bbb';

    if (userID.isEmpty) {
      return false;
    }

    Uri url;
    if (Platform.isAndroid) {
      url = Uri.http('10.0.2.2:4000', '/token');
    } else {
      url = Uri.http('localhost:4000', '/token');
    }

    Map<String, String> headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'userId': userID,
    });

    var tokenResponse = await http.post(url, body: body, headers: headers);

    var userToken = jsonDecode(tokenResponse.body)['token'];

    await client.value
        .connectUser(User(id: userID), userToken)
        .then((response) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
    return true;
  }

  void fetchUsers(BuildContext context) async {
    loadingData.value = true;

    await StreamChat.of(context).client.queryUsers(
      filter: Filter.and(
          [Filter.notEqual("id", StreamChat.of(context).currentUser!.id)]),
      sort: [const SortOption('last_message_at')],
    ).then((value) {
      if (value.users.length > 0) {
        userList.value = value.users.where((element) {
          return element.id != StreamChat.of(context).currentUser!.id;
        }).toList();
      }
      print(userList);
      loadingData.value = false;
    }).catchError((error) {
      loadingData.value = false;
      print(error);
    });

    print('Fetch Done=======');
  }

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
}
