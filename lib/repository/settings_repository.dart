import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository {
  static const _keyIsDark = 'is_dark_mode';

  /// Charge le paramètre `isDark` depuis les préférences locales.
  /// Retourne `false` par défaut si la clé n'existe pas.
  Future<bool> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDark) ?? false;
  }

  /// Sauvegarde la valeur de `isDark` dans les préférences.
  Future<void> saveSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, value);
  }
}
