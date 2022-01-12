import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream_chat;

class AuthUser {
  late firebase.User firebaseUser;
  late stream_chat.User streamChatUser;
  late stream_chat.Channel streamChatChannel;
  late String id;
  late String name;

  AuthUser({
    firebase.User? firebaseUser,
    stream_chat.User? streamChatUser,
    stream_chat.Channel? streamChatChannel,
    String? id,
    String? name,
  });
}
