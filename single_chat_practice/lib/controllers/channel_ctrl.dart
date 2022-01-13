import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelController extends GetxController {
  Future<void> sendCommand(Message message) async {
    Uri url;
    if (Platform.isAndroid) {
      url = Uri.http('10.0.2.2:4000', '/save');
    } else {
      url = Uri.http('localhost:4000', '/save');
    }

    Map<String, String> headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'userId': message.user!.id.toString(),
      'message': message.text,
    });

    var response = await http.post(url, body: body, headers: headers);

    print(utf8.decode(response.bodyBytes));
  }
}
