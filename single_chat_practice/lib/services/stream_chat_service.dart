import 'dart:convert';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'api_service.dart';

class StreamChatService extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;

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
}
