import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/api_service.dart';
import 'package:single_chat_practice/services/platfrom_service.dart';
import 'package:logger/logger.dart';

abstract class AuthInterface {
  loginCheck(AuthUser authUser);
  signInWithGoogle();
}

class FirebaseService extends GetxService implements AuthInterface {
  final initDone = false.obs;

  Future<void> init() async {
    Get.find<PlatformService>().isWeb
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: 'AIzaSyDw3YlKnKxs1exfZLziL3NdJ4592XtkE0s',
              appId: '1:963875283913:web:0de6f986e5ae7742b3be18',
              messagingSenderId: '963875283913',
              projectId: 'stream-chat-149e5',
            ),
          )
        : await Firebase.initializeApp();
    initDone.value = true;
    Logger().d("==== FirebaseService Init ====");
  }

  //loginCheck when you start application
  @override
  Future<bool> loginCheck(AuthUser authUser) async {
    User? user = FirebaseAuth.instance.currentUser;
    String body = json.encode({'email': user!.email});

    final data = await ApiService()
        .request(type: 'post', action: 'login-check', body: body);

    if (data['email'] != user.email) {
      return false;
    }

    authUser.id = data['id'];
    authUser.name = data['name'];

    return true;
  }

  //login with google
  @override
  Future<User> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    late final GoogleSignIn googleSignIn;

    if (Get.find<PlatformService>().isWeb) {
      googleSignIn = GoogleSignIn();
    } else {
      googleSignIn = Platform.isAndroid
          ? GoogleSignIn(scopes: ['profile', 'email'])
          : GoogleSignIn();
    }

    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    final UserCredential authResult =
        await auth.signInWithCredential(credential);
    return authResult.user!;
  }

  //logout from google
  Future<void> signOutWithGoogle() async {
    await FirebaseAuth.instance.signOut();
  }
}
