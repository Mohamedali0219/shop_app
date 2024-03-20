import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
    //! getInstance => from type 'Future<SharedPreferences>'
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> setThemeValue(
      {required String key, required bool value}) async {
    //! set Boolean => from type 'Future<bool>'
    return await sharedPreferences.setBool(key, value);
  }

  static bool? getThemeValue({required String key}) {
    return sharedPreferences.getBool(key);
  }

  //? handling data in shared preferences professionally

  static Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  Future<bool?> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}
