import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:logger/logger.dart' as lgr;

class NotificationService extends GetxService {
  late FirebaseMessaging _firebaseMessaging;
  final streamChatService = Get.find<StreamChatService>();
  String messageIdTemp = '';

  void init() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.onTokenRefresh.listen((token) async {
      streamChatService.client.value.addDevice(token, PushProvider.firebase);
    });

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    lgr.Logger().d("==== NotificationService Init ====");
  }

  //Background Notification
  void backgroundNotification(Event event) async {
    final client = streamChatService.client.value;
    showNotification(client, event);
  }

  //Showing Notification
  showNotification(StreamChatClient client, Event event) async {
    //null filtering
    if (![EventType.messageNew, EventType.notificationMessageNew]
            .contains(event.type) ||
        client.state.currentUser!.id == event.message!.user!.id) {
      return;
    }
    if (event.message == null) {
      return;
    }

    //notification settings
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('launch_background'),
      iOS: IOSInitializationSettings(),
    );

    if (event.message!.id != messageIdTemp) {
      messageIdTemp = event.message!.id;
      //generate notification
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
      //show notification
      await flutterLocalNotificationsPlugin.show(
        event.message!.id.hashCode,
        event.message!.user!.name,
        event.message!.text,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'message channel id',
            'Message Channel Name',
            channelDescription: 'Channel used for showing messages',
            priority: Priority.high,
            importance: Importance.high,
          ),
          iOS: IOSNotificationDetails(),
        ),
      );
    }
  }
}
