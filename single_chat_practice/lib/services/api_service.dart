import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService.init();

  factory ApiService() {
    return _instance;
  }

  ApiService.init() {
    Logger().d('ApiService Created!');
  }

  final server = '1bc7-121-134-227-161.ngrok.io';

  request(
      {required String type,
      required String action,
      String? body,
      Map<String, dynamic>? params}) async {
    Logger().d(action);
    late http.Response response;
    switch (type) {
      case 'post':
        Uri uri = Uri.http(server, '/$action');
        response = await post(uri, body!);
        break;
      case 'get':
        Uri uri = Uri.http(server, '/$action');
        response = await get(uri);
        break;
      case 'delete':
      case 'put':
        break;
    }

    if (response.statusCode != 200) {
      Logger().d('====Failed : ${response.statusCode}====');
      return;
    }

    Logger().d(utf8.decode(response.bodyBytes));
    return json.decode(utf8.decode(response.bodyBytes));
  }

  //post api operation
  Future<http.Response> post(Uri uri, String body) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Logger().d(headers);
    Logger().d(body);
    var response = await http.post(uri, headers: headers, body: body);
    return response;
  }

  //get api operation
  Future<http.Response> get(Uri uri) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    var response = await http.get(uri, headers: headers);

    return response;
  }
}
