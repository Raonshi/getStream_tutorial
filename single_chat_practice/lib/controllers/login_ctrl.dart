import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/firebase_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:logger/logger.dart' as lgr;

class LoginController extends GetxController {
  RxBool isLogin = false.obs;
  final authUser = AuthUser().obs;

  final firebaseService = Get.find<FirebaseService>();
  final streamChatService = Get.find<StreamChatService>();

  @override
  void onInit() async {
    super.onInit();
    await firebaseService.loginCheck(authUser.value);

    if (firebaseService.isLogin.value) {
      lgr.Logger().d("LOGIN");
      await login();
    }
  }

  //register your account
  Future<void> register() async {
    UserCredential authResult = await firebaseService.signInWithGoogle();
    authUser.value.firebaseUser = authResult.user!;
    await streamChatService.connect(authUser.value);
    isLogin.value = true;
  }

  //login your account
  Future<void> login() async {
    //stream_chat auth
    await streamChatService.connect(authUser.value);

    isLogin.value = firebaseService.isLogin.value;
  }
}
