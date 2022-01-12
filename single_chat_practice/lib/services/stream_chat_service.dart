import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatService extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;

  //connect client
  Future<void> connect(AuthUser authUser) async {
    Uri url = Platform.isAndroid
        ? Uri.http('10.0.2.2:4000', '/token')
        : Uri.http('localhost:4000', '/token');

    Map<String, String> headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'userId': authUser.firebaseUser.email!,
    });

    var tokenResponse = await http.post(url, body: body, headers: headers);
    var userToken = jsonDecode(tokenResponse.body)['token'];

    await client.value
        .connectUser(
      User(
        id: authUser.id,
        name: authUser.name,
        extraData: {'email': authUser.firebaseUser.email},
      ),
      userToken,
    )
        .then((response) {
      return true;
    }).catchError((error) {
      return false;
    });
  }
}
