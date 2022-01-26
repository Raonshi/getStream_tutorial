import 'dart:convert';
import 'package:get/get.dart';
import 'package:single_chat_practice/services/api_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

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

    //dynamic data = ApiService().requestCommand('save', body);
    dynamic data =
        ApiService().request(type: 'post', action: 'save', body: body);

    lgr.Logger().d("==============================$data");
  }
}

class WebChannelController extends GetxController {
  late Channel channel;
  WebChannelController(this.channel);

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

    //dynamic data = ApiService().requestCommand('save', body);
    dynamic data =
        ApiService().request(type: 'post', action: 'save', body: body);

    lgr.Logger().d("==============================$data");
  }
}
