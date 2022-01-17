import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

abstract class WebInterface {
  post(String path, String body);
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
  final server = '49e5-121-134-227-161.ngrok.io';

  //post api operation
  @override
  Future<dynamic> post(String path, String body) async {
    Uri url = Uri.http(server, path);
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      Logger().d('${response.statusCode} Failed');
      return false;
    }

    var responseStr = utf8.decode(response.bodyBytes);
    var data = jsonDecode(responseStr) as Map<String, dynamic>;

    Logger().d('$data Success');
    return data;
  }
}
