import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart' as lgr;
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';

abstract class AuthInterface {
  Future<void> signInWithGoogle();
}

class FirebaseService extends GetxService implements AuthInterface {
  //final isLogin = false.obs;
  final streamChatController = Get.find<StreamChatService>();

  Future<bool> loginCheck(AuthUser authUser) async {
    bool result = false;
    User? user = FirebaseAuth.instance.currentUser;
    lgr.Logger().d(user!.email.toString());

    if (user != null) {
      return true;
    }

/*
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        lgr.Logger().d('User Signed out');
      } else {
        lgr.Logger().d('User Signed in : ${user.email}');

        if (user.email.toString() == FirebaseAuth.instance.currentUser!.email) {
          authUser.firebaseUser = user;
          result = true;
        }
      }
    });
*/
    lgr.Logger().d("RESULT : $result");
    return result;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    UserCredential authResult = await auth.signInWithCredential(credential);

    return authResult;
  }
}
