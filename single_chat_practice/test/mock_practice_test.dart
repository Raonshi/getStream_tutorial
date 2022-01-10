import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_chat_practice/controllers/firebase_controller.dart';

import 'mock_practice_test.mocks.dart';

AuthUser user = AuthUser.create('test', 'test@test.io');

class TestClass implements AuthInterface {
  @override
  Future<AuthUser> signInWithGoogle() async {
    return user;
  }

  Future<bool> test() async {
    AuthUser tmp = await signInWithGoogle();
    return tmp.email.contains('test') ? true : false;
  }
}

@GenerateMocks([AuthInterface])
void main() {
  test('testing_true', () async {
    final mock = MockAuthInterface();
    final test = TestClass();

    when(mock.signInWithGoogle()).thenAnswer((_) async => user);
    final result = await test.test();

    expect(result, true);
  });
}
