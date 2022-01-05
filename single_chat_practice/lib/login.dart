import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:http/http.dart' as http;

import 'user_list.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userIDController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO);

  @override
  void dispose() {
    _userIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                  'Enter your unique user id',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  controller: _userIDController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCBD2D9),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    final userID = _userIDController.text.trim();

    if (userID.isEmpty) {
      SnackBar snackBar = SnackBar(content: Text('User ID is empty'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    Uri url;
    if (Platform.isAndroid) {
      url = Uri.http('10.0.2.2:4000', '/token');
    } else {
      url = Uri.http('localhost:4000', '/token');
    }

    Map<String, String> headers = new Map();
    headers['Content-Type'] = 'application/json';
    var body = json.encode({
      'userId': userID,
    });

    var tokenResponse = await http.post(url, body: body, headers: headers);
    var userToken = jsonDecode(tokenResponse.body)['token'];

    await _client.connectUser(User(id: userID), userToken).then((response) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamChat(
            client: _client,
            child: UsersListPage(),
          ),
        ),
      );
    }).catchError((error) {
      print(error);
      SnackBar snackBar = SnackBar(content: Text('Could not login user'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
