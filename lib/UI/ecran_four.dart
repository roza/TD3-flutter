import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:td3/ViewModel/setting_view_model.dart';
import 'package:td3/UI/mytheme.dart';

class Ecran4 extends StatelessWidget {
  const Ecran4({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingViewModel>();

    return Center(
      child: SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: MyTheme.dark().scaffoldBackgroundColor,
          settingsSectionBackground: MyTheme.dark().scaffoldBackgroundColor,
        ),
        lightTheme: SettingsThemeData(
          settingsListBackground: MyTheme.light().scaffoldBackgroundColor,
          settingsSectionBackground: MyTheme.light().scaffoldBackgroundColor,
        ),
        sections: [
          SettingsSection(
            title: const Text('Thème'),
            tiles: [
              SettingsTile.switchTile(
                initialValue: vm.isDark,
                onToggle: (value) =>
                    context.read<SettingViewModel>().isDark = value,
                title: const Text('Mode sombre'),
                leading: const Icon(Icons.invert_colors),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
