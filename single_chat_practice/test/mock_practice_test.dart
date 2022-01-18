import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_chat_practice/services/firebase_service.dart';

import 'mock_practice_test.mocks.dart';

@GenerateMocks([AuthInterface])
void main() {
  group('firebase', () {
    test('google_sign_in_success', () async {
      bool testResult = false;

      final mock = MockAuthInterface();
      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'sunwon@somedomain.com',
        displayName: 'Sunwon',
      );

      when(mock.signInWithGoogle()).thenAnswer((_) async {
        final googleSignIn = MockGoogleSignIn();
        final signinAccount = await googleSignIn.signIn();
        final googleAuth = await signinAccount!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in.
        final auth = MockFirebaseAuth(mockUser: mockUser);
        final result = await auth.signInWithCredential(credential);
        return result;
      });

      for (int i = 0; i < fakeRegistedAccounts.length; i++) {
        UserCredential userCredential = await mock.signInWithGoogle();

        if (userCredential.user!.displayName ==
            fakeRegistedAccounts[i].displayName) {
          testResult = true;
          break;
        }
      }
      expect(testResult, true);
    });

    test('google_sign_in_fail', () async {
      bool testResult = false;

      final mock = MockAuthInterface();
      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'bob@somedomain.com',
        displayName: 'Deamon',
      );

      when(mock.signInWithGoogle()).thenAnswer((_) async {
        final googleSignIn = MockGoogleSignIn();
        final signinAccount = await googleSignIn.signIn();
        final googleAuth = await signinAccount!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in.
        final auth = MockFirebaseAuth(mockUser: mockUser);
        final result = await auth.signInWithCredential(credential);
        return result;
      });

      for (int i = 0; i < fakeRegistedAccounts.length; i++) {
        UserCredential userCredential = await mock.signInWithGoogle();
        if (userCredential.user!.displayName ==
            fakeRegistedAccounts[i].displayName) {
          testResult = true;
          break;
        }
      }

      expect(testResult, false);
    });
  });
}

List<MockUser> fakeRegistedAccounts = [
  MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'sunwon@somedomain.com',
    displayName: 'Sunwon',
  ),
  MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'heater@somedomain.com',
    displayName: 'Heater',
  ),
  MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'iceage@somedomain.com',
    displayName: 'Iceage',
  ),
  MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'stone@somedomain.com',
    displayName: 'Stone',
  ),
  MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'raon@somedomain.com',
    displayName: 'Raon',
  ),
];
