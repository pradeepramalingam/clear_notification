import 'package:clear_notification_example/utils/import_utils_class_package.dart';

enum _SharedPrefsKeys {
  fcmToken,
  apnsToken,
  isUserLoggedIn,
}

class SharedPrefs {
  static final SharedPrefs _sharedInstance = SharedPrefs._internal();
  SharedPrefs._internal();
  static SharedPrefs get instance => _sharedInstance;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> clearAllPrefs() async {
    final SharedPreferences prefs = await _prefs;
    var fcmToken = await getFCMToken();
    var apnsToken = await getAPNsToken();
    prefs.clear();
    await setFCMToken(fcmToken);
    await setAPNsToken(apnsToken);
  }

  Future _setStringValue(_SharedPrefsKeys sharedPrefKey, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(sharedPrefKey.name, value);
  }

  Future<String?> _getStringValue(_SharedPrefsKeys sharedPrefKey) async {
    try {
      final SharedPreferences prefs = await _prefs;
      return prefs.getString(sharedPrefKey.name);
    }
    catch (error) {
      debugPrint('key: ${sharedPrefKey.name}, error: ${error.toString()}');
      return null;
    }
  }

  Future _setBoolValue(_SharedPrefsKeys sharedPrefKey, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(sharedPrefKey.name, value);
  }

  Future<bool?> _getBoolValue(_SharedPrefsKeys sharedPrefKey) async {
    try {
      final SharedPreferences prefs = await _prefs;
      return prefs.getBool(sharedPrefKey.name);
    }
    catch (error) {
      debugPrint('key: ${sharedPrefKey.name}, error: ${error.toString()}');
      return null;
    }
  }
  
  Future setFCMToken(String token) async {
    _setStringValue(_SharedPrefsKeys.fcmToken, token);
  }

  Future<String> getFCMToken() async {
    return (await _getStringValue(_SharedPrefsKeys.fcmToken)).nonNullValue();
  }

  Future setAPNsToken(String token) async {
    _setStringValue(_SharedPrefsKeys.apnsToken, token);
  }

  Future<String> getAPNsToken() async {
    return (await _getStringValue(_SharedPrefsKeys.apnsToken)).nonNullValue();
  }

  Future setIsUserLoggedIn(bool value) async {
    _setBoolValue(_SharedPrefsKeys.isUserLoggedIn, value);
  }

  Future<bool> getIsUserLoggedIn() async {
    return (await _getBoolValue(_SharedPrefsKeys.isUserLoggedIn)) ?? false;
  }
}
