import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({Key? key}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<User> _userList = [];
  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadingData = true;
    });

    StreamChat.of(context)
        .client
        .queryUsers(sort: [SortOption('last_message_at')]).then((value) {
      setState(() {
        if (value.users.isNotEmpty) {
          _userList = value.users.where((element) {
            return element.id != StreamChat.of(context).currentUser!.id;
          }).toList();
        }
        _loadingData = false;
      });
    }).catchError((error) {
      setState(() {
        _loadingData = false;
      });
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loadingData
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _userList.isEmpty
                ? Container(
                    child: const Center(child: Text('Could not fetch users')))
                : ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_userList[index].name),
                        onTap: () async {
                          var client = StreamChat.of(context).client;
                          var currentUser = StreamChat.of(context).currentUser;

                          late Channel channel;

                          await client
                              .channel('messaging', extraData: {
                                'members': [
                                  currentUser!.id,
                                  _userList[index].id
                                ]
                              })
                              .create()
                              .then((response) {
                                channel = Channel.fromState(client, response);
                                channel.watch();
                              })
                              .catchError((error) {
                                print(error);
                              });

                          if (channel != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return StreamChannel(
                                    child: ChannelPage(),
                                    channel: channel,
                                  );
                                },
                              ),
                            );
                          } else {}
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: _userList.length),
      ),
    );
  }
}
