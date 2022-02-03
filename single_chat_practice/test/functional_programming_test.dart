import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  group('Functional Programming Practice', () {
    test('test', () async {
      List<int> list = [1, 1, 3, 6, 5, 4, 7, 0, 8, 9];
      final result = list.toSet();
      Logger().d(result);
    });
  });
}

late List<TestObject> testerList;

class TestObject {
  final String id;
  final String password;
  final String userName;

  TestObject({
    required this.id,
    required this.password,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'PASSWORD': password,
      'USERNAME': userName,
    };
  }

  factory TestObject.fromJson(dynamic data) {
    return TestObject(
      id: data['ID'] as String,
      password: data['PASSWORD'] as String,
      userName: data['USERNAME'] as String,
    );
  }
}

String data =
    '{{"ID": "tester1", "PASSWORD": "1234", "userName": "Bob"}, {"ID": "tester2", "PASSWORD": "5678", "userName": "Jack"}';
