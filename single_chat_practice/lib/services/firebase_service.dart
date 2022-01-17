import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart' as lgr;
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/api_service.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';

abstract class AuthInterface {
  Future<void> signInWithGoogle();
}

class FirebaseService extends GetxService implements AuthInterface {
  //final isLogin = false.obs;
  final streamChatController = Get.find<StreamChatService>();

  //loginCheck when you start application
  Future<bool> loginCheck(AuthUser authUser) async {
    bool result = false;
    User? user = FirebaseAuth.instance.currentUser;
    String body = json.encode({'email': user!.email});

    var data = await ApiService().post('/loginCheck', body);

    if (data['email'] != user.email) return false;

    authUser.id = data['id'];
    authUser.name = data['name'];
    return true;
  }

  //login with google
  @override
  Future<UserCredential> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = Platform.isAndroid
        ? GoogleSignIn(scopes: ['profile', 'email'])
        : GoogleSignIn();

    GoogleSignInAccount? account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    UserCredential authResult = await auth.signInWithCredential(credential);

    return authResult;
  }

  //logout from google
  Future<void> signOutWithGoogle() async {
    await FirebaseAuth.instance.signOut();
  }
}
