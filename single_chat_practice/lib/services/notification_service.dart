import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationService extends GetxService {
  Future<void> foregroundNotification() async {
    final client = Get.find<StreamChatService>().client.value;
    client
        .on(EventType.messageNew, EventType.notificationMessageNew)
        .listen((event) async {
      if (event.message?.user?.id == client.state.currentUser?.id) {
        return;
      }

      //ios, android 기기에 따른 알림 설정
      const initializationSettingsAndroid =
          AndroidInitializationSettings('launch_background');
      const initializationSettingsIOS = IOSInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      //플러그인 생성
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      //알림 설정 값을 적용해서 initialization
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      //알림을 출력한다.
      await flutterLocalNotificationsPlugin.show(
        event.message!.id.hashCode,
        event.message!.user!.name,
        event.message!.text,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Channel ID',
            'Channel Name',
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
