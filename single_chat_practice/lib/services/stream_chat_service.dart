import 'dart:convert';
import 'package:get/get.dart';
import 'package:single_chat_practice/etc/auth_user.dart';
import 'package:single_chat_practice/services/notification_service.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'api_service.dart';
import 'package:logger/logger.dart' as lgr;

abstract class ChattingInterface {
  connect(AuthUser authUser);
  disconnect();
  createChattingRoom();
  fetchUsers();
}

class StreamChatService extends GetxService implements ChattingInterface {
  final initDone = false.obs;
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;
  final selectedUser = <User>{}.obs;
  final loadingData = true.obs;
  final userList = [].obs;

  void init() => lgr.Logger().d("==== StreamChatService Init ====");

  //connect client
  @override
  Future<User> connect(AuthUser authUser) async {
    //request to server and response
    final data = await ApiService().request(
      type: 'post',
      action: 'token',
      body: json.encode({
        'userId': authUser.id,
        'name': authUser.name,
        'email': authUser.firebaseUser.email!
      }),
    );

    final User user = await streamChatConnect(
      User(
          id: authUser.id,
          name: authUser.name,
          extraData: {'email': authUser.firebaseUser.email}),
      data['token'],
    );

    listenForegroundNotification(client.value);
    return user;
  }

  Future<User> streamChatConnect(User user, String userToken) async {
    //connect client to stream server
    bool connectSuccess = await client.value
        .connectUser(user, userToken)
        .then((response) => true)
        .catchError((error) => false);
    return connectSuccess ? user : User(id: 'Unknown');
  }

  void listenForegroundNotification(StreamChatClient client) {
    //listen notification event
    client
        .on(EventType.messageNew, EventType.notificationMessageNew)
        .listen((event) async {
      Get.find<NotificationService>().showNotification(client, event);
    });
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
  void fetchUsers() async {
    try {
      userList.value = await getUserList(client.value);
      loadingData.value = false;
    } catch (e) {
      loadingData.value = true;
    }
  }

  Future<List<User>> getUserList(StreamChatClient client) async {
    late final List<User> users;
    await client.queryUsers(
      filter: Filter.and([
        //나를 제외한 모든 유저 표시
        Filter.notEqual('id', client.state.currentUser!.id),
      ]),
      sort: const [SortOption('last_message_at')],
    ).then((value) {
      if (value.users.isNotEmpty) {
        users = value.users.where((element) {
          return element.id != client.state.currentUser!.id;
        }).toList();
      }
    });
    return users;
  }
}
