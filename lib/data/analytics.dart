import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static final FirebaseAnalytics _analytics = new FirebaseAnalytics();

  static FirebaseAnalytics instance() {
    return _analytics;
  }
}