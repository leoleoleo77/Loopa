import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt mGetIt = GetIt.instance;

Future<void> setupLocator() async {
  // Register SharedPreferences as a singleton
  final sharedPreferences = await SharedPreferences.getInstance();
  mGetIt.registerSingleton<SharedPreferences>(sharedPreferences);
}