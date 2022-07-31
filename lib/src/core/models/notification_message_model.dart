import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationMessageModel {
  String? title;
  String? body;
  String? link;
  String? isMessage;
  String? imageUrl;

  NotificationMessageModel({
    this.title,
    this.body,
    this.link,
    this.isMessage,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'NotificationMessageModel(title: $title, body: $body, link: $link, isMessage: $isMessage, imageUrl: $imageUrl)';
  }

  factory NotificationMessageModel.fromRemoteMessage(
      RemoteMessage remoteMessage) {
    NotificationMessageModel notificationMessageModel =
        NotificationMessageModel(
      title: remoteMessage.notification?.title,
      body: remoteMessage.notification?.body,
      link: remoteMessage.data['link'] as String?,
      isMessage: remoteMessage.data['is_message'] as String?,
    );
    if (remoteMessage.notification?.android?.imageUrl != null) {
      return notificationMessageModel.copyWith(
        imageUrl: remoteMessage.notification!.android!.imageUrl,
      );
    } else if (remoteMessage.notification?.apple?.imageUrl != null) {
      return notificationMessageModel.copyWith(
        imageUrl: remoteMessage.notification!.apple!.imageUrl,
      );
    }
    return notificationMessageModel.copyWith(
        imageUrl: remoteMessage.notification?.web?.image);
  }

  factory NotificationMessageModel.fromMap(Map<String, dynamic> data) {
    return NotificationMessageModel(
      title: data['title'] as String?,
      body: data['body'] as String?,
      link: data['link'] as String?,
      isMessage: data['is_message'] as String?,
      imageUrl: data['image_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'link': link,
        'is_message': isMessage,
        'image_url': imageUrl,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NotificationMessageModel].
  factory NotificationMessageModel.fromJson(String data) {
    return NotificationMessageModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NotificationMessageModel] to a JSON string.
  String toJson() => json.encode(toMap());

  NotificationMessageModel copyWith({
    String? title,
    String? body,
    String? link,
    String? isMessage,
    String? imageUrl,
  }) {
    return NotificationMessageModel(
      title: title ?? this.title,
      body: body ?? this.body,
      link: link ?? this.link,
      isMessage: isMessage ?? this.isMessage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
