import 'dart:convert';
import 'package:get/get.dart';
import 'package:single_chat_practice/services/api_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelController extends GetxController {
  //send custom command
  Future<void> sendCommand(Message message) async {
    if (message.text == null) {
      return;
    }
    if (message.text!.contains('/save')) {
      await save(message);
    }
  }

  Future<void> save(Message message) async {
    var body = json.encode({
      'userId': message.user!.id.toString(),
      'message': message.text,
    });
    /*
    dynamic data = await ApiService().post(
      '/custom-command',
      body,
      command: 'save',
    );
    */

    dynamic data = ApiService().requestCommand('save', body);
  }
}
