import 'dart:convert';

import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryManager {
  static final SharedPreferences _prefs = mGetIt.get<SharedPreferences>();

  static Future<bool> saveLoopa(Loopa loopa) async {
    int id = loopa.id;
    String jsonLoopa = jsonEncode(loopa.toJson());
    if (jsonLoopa == getLoopaData(loopa.id)) return false;

    return await _prefs.setString(id.toString(), jsonLoopa);
  }

  static Future<bool> deleteLoopa(Loopa loopa) async {
    return await _prefs.remove(loopa.id.toString());
  }

  static String? getLoopaData(int key) => _prefs.getString(key.toString());

  static Future<bool> saveLastVisitedKey(String key) async {
    return await _prefs.setString(LoopaKeys.lastVisited, key);
  }

  static String? get getLastVisitedKey =>
      _prefs.getString(LoopaKeys.lastVisited);
 }