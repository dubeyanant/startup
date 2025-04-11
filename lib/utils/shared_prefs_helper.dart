import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_invest/modules/login/provider/user_type_provider.dart'; // For UserType enum

class SharedPrefsHelper {
  static const String _loggedInEmailKey = 'loggedInEmail';
  static const String _userTypeKey = 'userType';

  // Private constructor for singleton pattern
  SharedPrefsHelper._privateConstructor();
  static final SharedPrefsHelper _instance =
      SharedPrefsHelper._privateConstructor();

  // Static instance getter
  static SharedPrefsHelper get instance => _instance;

  // Save login information
  Future<void> saveLoginInfo(String email, UserType userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInEmailKey, email);
    await prefs.setString(_userTypeKey, userType.name);
  }

  // Get login information
  Future<(String?, UserType?)> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString(_loggedInEmailKey);
    final String? userTypeName = prefs.getString(_userTypeKey);
    final UserType? userType =
        userTypeName != null ? UserType.values.byName(userTypeName) : null;
    return (email, userType);
  }

  // Clear login information
  Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInEmailKey);
    await prefs.remove(_userTypeKey);
  }
}
