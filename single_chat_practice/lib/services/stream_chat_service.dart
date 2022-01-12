import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatService extends GetxService {
  final client = StreamChatClient('grdysyd7gzfn', logLevel: Level.INFO).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //connect client
  Future<void> connect(User user, String token) async {
    await client.value.connectUser(user, token).then((response) {
      return true;
    }).catchError((error) {
      return false;
    });
  }
}
