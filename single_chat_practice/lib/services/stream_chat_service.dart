import 'dart:convert';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'api_service.dart';
import 'package:logger/logger.dart' as lgr;

abstract class ChattingInterface {
  connect(AuthUser authUser);
  disconnect();
  createChattingRoom();
  fetchUsers(StreamChatClient client);
}

class StreamChatService extends GetxService implements ChattingInterface {
  final initDone = false.obs;
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;
  final selectedUser = <User>{}.obs;
  final loadingData = true.obs;
  final userList = [].obs;

  void init() {
    lgr.Logger().d("==== StreamChatService Init ====");
  }

  //connect client
  @override
  Future<User> connect(AuthUser authUser) async {
    final body = json.encode({
      'userId': authUser.id,
      'name': authUser.name,
      'email': authUser.firebaseUser.email!
    });

    //request to server and response
    final data =
        await ApiService().request(type: 'post', action: 'token', body: body);
    final userToken = data['token'];

    //user infomation serialize
    User user = User(
      id: authUser.id,
      name: authUser.name,
      extraData: {'email': authUser.firebaseUser.email},
    );

    //connect client to stream server
    await client.value.connectUser(user, userToken).then((response) {
      return true;
    }).catchError((error) {
      return false;
    });

    //listen notification event
    client.value
        .on(EventType.messageNew, EventType.notificationMessageNew)
        .listen((event) async {
      Get.find<NotificationService>().showNotification(client.value, event);
    });

    return user;
  }

  //dispose
  @override
  Future<void> disconnect() async => await client.value.disconnectUser();

  @override
  Future<Channel> createChattingRoom() async {
    final currentUser = client.value.state.currentUser;
    final List<String> members = List<String>.generate(
      selectedUser.length + 1,
      (index) {
        return index == selectedUser.length
            ? currentUser!.id
            : selectedUser.elementAt(index).id;
      },
    );

    late final Channel channel;

    await client.value
        .channel('messaging', extraData: {'members': members})
        .create()
        .then((response) {
          channel = Channel.fromState(client.value, response);
          channel.watch();
        });

    selectedUser.clear();
    return channel;
  }

  @override
  void fetchUsers(StreamChatClient client) async {
    await client.queryUsers(
      filter: Filter.and([
        //나를 제외한 모든 유저 표시
        Filter.notEqual('id', client.state.currentUser!.id),
      ]),
      sort: const [SortOption('last_message_at')],
    ).then((value) {
      if (value.users.isNotEmpty) {
        userList.value = value.users.where((element) {
          return element.id != client.state.currentUser!.id;
        }).toList();
      }
    }).catchError((e) {
      loadingData.value = true;
    });
    loadingData.value = false;
  }
}
