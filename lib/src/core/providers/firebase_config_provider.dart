import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pickpointer/src/core/enums/platform_enum.dart';

class FirebaseConfigProvider {
  static FirebaseConfigProvider? _instance;

  static FirebaseRemoteConfig firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  static FirebaseConfigProvider? getInstance() {
    _instance ??= FirebaseConfigProvider();
    firebaseRemoteConfig.fetchAndActivate();
    return _instance;
  }

  String getMinimalVersion(PlatformEnum platformEnum) {
    String version =
        firebaseRemoteConfig.getString('minimal_version_${platformEnum.label}');
    print('minimal_version_${platformEnum.label} $version');
    return version;
  }
}
