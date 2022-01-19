import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

abstract class WebInterface {
  post(Uri uri, String body);
}

class ApiService implements WebInterface {
  static final ApiService _instance = ApiService.init();

  factory ApiService() {
    return _instance;
  }

  ApiService.init() {
    Logger().d('ApiService Created!');
  }

  //final server = Platform.isAndroid ? '10.0.2.2:4000' : 'localhost:4000';
  final server = '2e0a-121-134-227-161.ngrok.io';

  //post api operation
  @override
  Future<http.Response> post(Uri uri, String body) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var response = await http.post(uri, headers: headers, body: body);
    return response;
  }

  requestToken(String body) async {
    Uri uri = Uri.http(server, '/token');
    http.Response response = await post(uri, body);

    if (response.statusCode != 200) {
      return;
    }

    dynamic jsonResult = utf8.decode(response.bodyBytes);
    return json.decode(jsonResult);
  }

  requestLoginCheck(String body) async {
    Uri uri = Uri.http(server, '/loginCheck');
    http.Response response = await post(uri, body);

    if (response.statusCode != 200) {
      return;
    }

    dynamic jsonResult = utf8.decode(response.bodyBytes);
    return json.decode(jsonResult);
  }

  requestCommand(String command, String body) async {
    Uri uri = Uri.http(server, '/custom-command', {'type': command});
    http.Response response = await post(uri, body);
  }
}
