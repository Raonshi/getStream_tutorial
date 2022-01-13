import 'dart:convert';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'api_service.dart';

class StreamChatService extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;

  //connect client
  Future<void> connect(AuthUser authUser) async {
    var body = json.encode({
      'userId': authUser.id,
      'name': authUser.name,
      'email': authUser.firebaseUser.email!
    });

    dynamic data = await ApiService().post('/token', body);
    var userToken = data['token'];

    User user = User(
      id: authUser.id,
      name: authUser.name,
      extraData: {'email': authUser.firebaseUser.email},
    );

    await client.value.connectUser(user, userToken).then((response) {
      return true;
    }).catchError((error) {
      return false;
    });

    authUser.streamChatUser = user;
  }

  Future<void> disconnect() async {
    await client.value.disconnectUser();
  }
}
