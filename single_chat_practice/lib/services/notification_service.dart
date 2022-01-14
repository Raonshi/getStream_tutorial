import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:logger/logger.dart' as lgr;

class NotificationService extends GetxService {
  late FirebaseMessaging _firebaseMessaging;
  final streamChatService = Get.find<StreamChatService>();

  @override
  void onInit() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.onTokenRefresh.listen((token) async {
      streamChatService.client.value.addDevice(token, PushProvider.firebase);
    });

    super.onInit();
  }

  void backgroundNotification(Event event) async {
    final client = streamChatService.client.value;

    if (![EventType.messageNew, EventType.notificationMessageNew]
            .contains(event.type) ||
        event.user!.id == client.state.currentUser!.id) {
      return;
    }
    if (event.message == null) {
      return;
    }

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'launch_background',
    );

    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin.show(
      event.message!.id.hashCode,
      event.message!.user!.name,
      event.message!.text,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'message channel',
          'Message channel',
          channelDescription: 'Channel used for showing messages',
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: IOSNotificationDetails(),
      ),
    );
  }

  void foregroundNotification() {
    final client = streamChatService.client.value;

    streamChatService.client.value
        .on(EventType.messageNew, EventType.notificationMessageNew)
        .listen((event) async {
      if (![EventType.messageNew, EventType.notificationMessageNew]
              .contains(event.type) ||
          event.user!.id == client.state.currentUser!.id) {
        return;
      }
      if (event.message == null) {
        return;
      }

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const initializationSettingsAndroid = AndroidInitializationSettings(
        'launch_background',
      );

      const initializationSettingsIOS = IOSInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (channelCid) async {
          if (channelCid != null) {
            var channel = client.state.channels[channelCid];

            if (channel == null) {
              final splits = channelCid.split(':');
              final type = splits[0];
              final id = splits[1];
              channel = client.channel(
                type,
                id: id,
              );

              await channel.watch();
            }

            lgr.Logger().d("Noti Click!");
          }
        },
      );

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
    });
  }
}
