import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart' as lgr;
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';

abstract class AuthInterface {
  Future<void> signInWithGoogle();
}

class FirebaseService extends GetxService implements AuthInterface {
  final isLogin = false.obs;
  final authUser = AuthUser().obs;

  final streamChatController = Get.find<StreamChatService>();

  @override
  void onInit() async {
    super.onInit();
    await login();
  }

  Future<void> login() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        lgr.Logger().d('User Signed out');
        isLogin.value = false;
      } else {
        lgr.Logger().d('User Signed in');
        authUser.value.firebaseUser = user;
        //isLogin.value = true;
      }
    });
  }

  @override
  Future<void> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    UserCredential authResult = await auth.signInWithCredential(credential);
  }
}
