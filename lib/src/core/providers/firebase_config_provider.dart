import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pickpointer/src/core/enums/platform_enum.dart';
import 'package:http/http.dart' as http;

class FirebaseConfigProvider {
  static FirebaseConfigProvider? _instance;

  static FirebaseRemoteConfig firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  static FirebaseConfigProvider? getInstance() {
    _instance ??= FirebaseConfigProvider();
    firebaseRemoteConfig.fetchAndActivate();
    return _instance;
  }

  Future<String> getMinimalVersion(PlatformEnum platformEnum) {
    Future<String> futureString = http
        .get(
      Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/pickpointer.appspot.com/o/remote_config%2Fremote_config.json?alt=media&token=35856045-b0b3-421a-b25b-baf76aa829b9'),
    )
        .then((http.Response value) {
      var data = json.decode(value.body);
      String version = data['minimal_version_${platformEnum.label}'];
      print('minimal_version_${platformEnum.label} $version');
      return version;
    });
    return futureString;
  }
}
