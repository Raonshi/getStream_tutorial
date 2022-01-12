import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class LoginController extends GetxController {
  RxBool isLogin = false.obs;
  RxString id = ''.obs;
  RxString name = ''.obs;

  final authUser = AuthUser().obs;

  final firebaseService = Get.find<FirebaseService>();
  final stramChatService = Get.find<StreamChatService>();

  void login() async {
    Uri url = Platform.isAndroid
        ? Uri.http('10.0.2.2:4000', '/token')
        : Uri.http('localhost:4000', '/token');

    Map<String, String> headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'userId': firebaseService.authUser.value.firebaseUser.email!,
    });

    var tokenResponse = await http.post(url, body: body, headers: headers);
    var userToken = jsonDecode(tokenResponse.body)['token'];

    stramChatService.connect(
        User(
          id: firebaseService.authUser.value.firebaseUser.email!,
          name: firebaseService.authUser.value.firebaseUser.displayName!,
        ),
        userToken);

    isLogin.value = firebaseService.isLogin.value;
  }
}
