import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loopa/firebase_options.dart';
import 'package:loopa/utils/log_utils/app_log.dart';
import 'package:loopa/utils/log_utils/log_constants.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class Log {
  static FirebaseAnalytics? _analytics;

  static void initializeFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    _analytics = FirebaseAnalytics.instance;
  }

  static void logLoopaChange({
    required int loopaId,
    required LoopaState loopaState
  }) {
    String eventName = LogNames.loopaChange;
    Map<String, Object> eventParams = {
      LogParameters.loopaId: "$loopaId",
      LogParameters.loopaState: "$loopaState",
      LogParameters.timeStamp: "${DateTime.now().toLocal()}",
    };

    /// Log event on firebase
    _analytics?.logEvent(
      name: eventName,
      parameters: eventParams);

    /// Debug print event on console
    DebugLog.firebaseEvent(eventName, eventParams);
  }
}