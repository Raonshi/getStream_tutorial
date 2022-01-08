import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseController extends GetxService {
  RxBool isLogin = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await Firebase.initializeApp();
    await signInWithGoogle();
  }

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
    User? user = authResult.user;
  }
}
