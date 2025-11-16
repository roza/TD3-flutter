import 'package:flutter/foundation.dart';
import 'package:td3/repository/settings_repository.dart';

class SettingViewModel extends ChangeNotifier {
  final SettingRepository _repo = SettingRepository();

  bool _isDark = false;
  bool _isInitialized = false;

  bool get isDark => _isDark;
  bool get isInitialized => _isInitialized;

  SettingViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final value = await _repo.getSettings();
      _isDark = value;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Erreur lors du chargement des paramètres: $e');
      }
    } finally {
      _isInitialized = true;
      // notifier après la fin du cycle courant pour éviter setState() during build
      Future.microtask(notifyListeners);
    }
  }

  set isDark(bool value) {
    if (_isDark == value) return;
    _isDark = value;
    _repo.saveSettings(value);
    notifyListeners();
  }
}
