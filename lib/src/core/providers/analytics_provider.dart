import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsProvider {
  static AnalyticsProvider? _instance;

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static AnalyticsProvider? getInstance() {
    _instance ??= AnalyticsProvider();
    return _instance;
  }

  initialize() {
    analytics.setAnalyticsCollectionEnabled(true);
  }
}
