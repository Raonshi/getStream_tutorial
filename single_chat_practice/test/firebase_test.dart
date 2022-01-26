import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

class MyHttpOverrides extends HttpOverrides {}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  test('TDD practice', () async {
    final client = HttpClient();
    HttpClientRequest request = await client.get('localhost', 80, '/file');
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    print(stringData);
  });
}

Future<String> dummyResponse(HttpClientRequest request) async {
  HttpClientResponse response = await request.close();
  final data = await response.transform(utf8.decoder).join();
  return data;
}
