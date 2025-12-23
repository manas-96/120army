import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static final Map<String, dynamic> _cache = {};

  static Future<void> saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, message);
    _cache[key] = message; // update cache also
  }

  static Future<dynamic> readPrefStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final value = pref.get(key);
    _cache[key] = value; // update cache also
    return value;
  }

  /// 🔹 Preload all values once (at app start)
  static Future<void> preload() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    for (var key in pref.getKeys()) {
      _cache[key] = pref.get(key);
    }
  }

  /// 🔹 Instant read from cache (fast, no async)
  static String? getCachedStr(String key) {
    return _cache[key] as String?;
  }
}

Future<String> getFullName() async {
  String? name = await SharedPrefUtils.readPrefStr("fullname");
  return name ?? "";
}
