import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationProvider {
  static NotificationProvider? _instance;

  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  static String channelKey = 'default_channel';
  static bool notificationEnabled = false;

  static NotificationProvider? getInstance() {
    _instance ??= NotificationProvider();
    return _instance;
  }

  initialize() {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'default_channel',
        channelName: 'Default Channel',
        channelDescription: 'Default Channel Description',
      ),
    ]);
  }

  Future<bool> checkPermission() async {
    bool isNotificationEnabled = false;
    isNotificationEnabled = await awesomeNotifications.isNotificationAllowed();
    if (!isNotificationEnabled) {
      isNotificationEnabled =
          await awesomeNotifications.requestPermissionToSendNotifications(
        channelKey: channelKey,
      );
    }
    notificationEnabled = isNotificationEnabled;
    return isNotificationEnabled;
  }

  Future<bool> sendLocalNotification({
    String? title,
    String? body,
    String? bigPicture,
    DateTime? dateTime,
  }) async {
    if (!notificationEnabled) checkPermission();
    if (notificationEnabled) {
      awesomeNotifications.createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: channelKey,
          title: title,
          body: body,
          notificationLayout: bigPicture != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          bigPicture: bigPicture,
        ),
        schedule: NotificationCalendar.fromDate(
          date: dateTime ?? DateTime.now(),
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
      return true;
    }
    return false;
  }
}
