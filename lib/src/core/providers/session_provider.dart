import 'package:pickpointer/src/core/providers/shared_preferences_provider.dart';

class SessionProvider {
  static final SessionProvider _singleton = SessionProvider._internal();

  factory SessionProvider() {
    return _singleton;
  }

  SessionProvider._internal();

  Future<String?> getSession() async {
    SharedPreferencesProvider sharedPreferencesProvider =
        await SharedPreferencesProvider.getInstance();
    dynamic sessionJson = sharedPreferencesProvider.getJson(key: 'session');
    if (sessionJson != null) {
      return sessionJson;
    }
    return null;
  }
}
