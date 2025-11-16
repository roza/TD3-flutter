import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:td3/ViewModel/setting_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingViewModel', () {
    test('charge correctement le thème depuis SharedPreferences', () async {
      // --- ARRANGE ---
      // Simule un SharedPreferences contenant is_dark_mode = true
      SharedPreferences.setMockInitialValues({'is_dark_mode': true});

      // --- ACT ---
      final vm = SettingViewModel();

      // On attend un petit délai pour laisser le microtask tourner
      await Future.delayed(const Duration(milliseconds: 10));

      // --- ASSERT ---
      expect(vm.isDark, true);
      expect(vm.isInitialized, true);
    });

    test('sauvegarde et notifie correctement', () async {
      // --- ARRANGE ---
      SharedPreferences.setMockInitialValues({});

      final vm = SettingViewModel();
      await Future.delayed(const Duration(milliseconds: 10));

      bool notified = false;
      vm.addListener(() {
        notified = true;
      });

      // --- ACT ---
      vm.isDark = true;

      // On laisse le temps à notifyListeners
      await Future.delayed(const Duration(milliseconds: 10));

      final prefs = await SharedPreferences.getInstance();

      // --- ASSERT ---
      expect(vm.isDark, true);
      expect(prefs.getBool('is_dark_mode'), true);
      expect(notified, true);
    });
  });
}
