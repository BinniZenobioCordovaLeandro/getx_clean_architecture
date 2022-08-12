import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pickpointer/src/core/models/notification_message_model.dart';
import 'package:http/http.dart' as http;

final _pushController = StreamController<NotificationMessageModel>.broadcast();

class FirebaseNotificationProvider {
  static FirebaseNotificationProvider? _instance;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Stream<NotificationMessageModel> get onMessage => _pushController.stream;

  static FirebaseNotificationProvider? getInstance() {
    _instance ??= FirebaseNotificationProvider();
    return _instance;
  }

  initialize() {
    checkPermission().then((bool isReady) {
      if (isReady) configure();
    });
  }

  Future<bool> configure() {
    messaging.setAutoInitEnabled(true);
    messaging.getInitialMessage().then(handlerMessage);
    FirebaseMessaging.onBackgroundMessage(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
    FirebaseMessaging.onMessage.listen(handlerMessage);

    return Future.value(true);
  }

  Future<void> handlerMessage(RemoteMessage? message) async {
    if (message != null) {
      NotificationMessageModel notificationMessageModel =
          NotificationMessageModel.fromRemoteMessage(message);
      _pushController.sink.add(notificationMessageModel);
    }
  }

  Future<bool> checkPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<String?> getToken() {
    return messaging.getToken();
  }

  Future<bool> sendMessage({
    required List<String>? to,
    required String title,
    required String body,
    String? image,
    Map<String, dynamic>? data,
  }) async {
    if (!await checkPermission()) return false;
    const decoder = JsonEncoder();
    const String url =
        'https://us-central1-pickpointer.cloudfunctions.net/sendNotification';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: {
        'token': decoder.convert(to),
        'payload': {
          'notification': {
            'title': title,
            'body': body,
            'image': image,
            'android': {
              'imageUrl': image,
            },
            'apple': {
              'imageUrl': image,
            },
            'web': {
              'image': image,
            }
          },
          'data': decoder.convert(data),
        },
        'options': {
          'priority': "high",
        }
      },
    );
    print('response.body: ${response.body}');
    return true;
  }
}
