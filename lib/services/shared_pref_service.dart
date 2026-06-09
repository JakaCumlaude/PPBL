import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<void> saveLogin({
    required String userId,
    required String userName,
    required String userRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userRole', userRole);
    await prefs.setString('themeMode', 'light');
    await prefs.setInt('points', 0);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
