import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:logger/logger.dart' as lgr;

class LoginController extends GetxController {
  RxBool isLogin = false.obs;
  final authUser = AuthUser().obs;

  final streamChatService = Get.put(StreamChatService());
  final firebaseService = Get.put(FirebaseService());

  @override
  void onInit() async {
    super.onInit();

    isLogin.value = await firebaseService.loginCheck(authUser.value);
    lgr.Logger().d("isLogin : ${isLogin.value.toString()}");

    //firebase auth에 유저 정보가 있다면
    if (isLogin.value) {
      lgr.Logger().d("LOGIN");
      await login();
    }
  }

  //register your account
  //just call when you click the sign up button in login page.
  Future<void> register() async {
    UserCredential authResult = await firebaseService.signInWithGoogle();
    authUser.value.firebaseUser = authResult.user!;
    await streamChatService.connect(authUser.value);
    isLogin.value = true;
  }

  //login your account
  Future<void> login() async {
    authUser.value.firebaseUser = FirebaseAuth.instance.currentUser!;
    //stream_chat auth
    await streamChatService.connect(authUser.value);
  }
}
