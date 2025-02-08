import 'dart:convert';

import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryManager {
  static final SharedPreferences _prefs = mGetIt.get<SharedPreferences>();

  static Future<bool> saveLoopa(Loopa loopa) async {
    String id = loopa.id.toString();
    String jsonLoopa = jsonEncode(loopa.toJson());
    await _prefs.setString(id, jsonLoopa);
    print(getLoopaInfo(loopa.id));
    return true;
  }

  // static List<String> getSavedIds() {
  //   return List.generate(
  //       LoopaConstants.maxNumberOfLoopas,
  //       (key) => key.toString())
  //         .where((key) => _prefs.containsKey(key))
  //         .toList();
  // }

  static String? getLoopaInfo(int key) => _prefs.getString(key.toString());
}