import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:logger/logger.dart' as lgr;

class LoginController extends GetxController {
  final isLogin = false.obs;
  final authUser = AuthUser().obs;

  final streamChatService = Get.find<StreamChatService>();
  final firebaseService = Get.find<FirebaseService>();

  @override
  void onInit() async {
    super.onInit();
    bool isCheck = await firebaseService.loginCheck(authUser.value);

    //if firebase has user's infomation
    if (isCheck) {
      authUser.value.firebaseUser = FirebaseAuth.instance.currentUser!;
      isLogin.value = await login();
    }

    lgr.Logger().d('=====login process done====');
  }

  //register your account
  //just call when you click the sign up button in login page.
  Future<void> register() async {
    authUser.value.firebaseUser = await firebaseService.signInWithGoogle();
    isLogin.value = await login();
  }

  //login your account
  Future<bool> login() async {
    try {
      authUser.value.streamChatUser =
          await streamChatService.connect(authUser.value);
      return true;
    } catch (e) {
      return false;
    }
  }

  //dispose
  Future<void> logout() async {
    await firebaseService.signOutWithGoogle();
    await streamChatService.disconnect();
    isLogin.value = false;
  }
}
