import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatClientController extends GetxService {
  final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    client.value.connectUser(
      User(id: 'tutorial-flutter'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c',
    );
  }
}
