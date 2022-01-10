import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthInterface {
  Future<AuthUser> signInWithGoogle();
}

class FirebaseController extends GetxService implements AuthInterface {
  @override
  void onInit() async {
    super.onInit();
    //await Firebase.initializeApp();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> login() async {
    await Firebase.initializeApp();

    AuthUser user = await signInWithGoogle();
    return user.uid != '' ? true : false;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    UserCredential authResult = await auth.signInWithCredential(credential);

    AuthUser user =
        AuthUser.create(authResult.user!.uid, authResult.user!.email);

    return user;
  }
}

class AuthUser {
  String uid = '';
  String email = '';

  AuthUser({required this.uid, required this.email});

  factory AuthUser.create(dynamic uid, dynamic email) {
    return AuthUser(uid: uid.toString(), email: email.toString());
  }
}
