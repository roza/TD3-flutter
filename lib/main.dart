import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td3/UI/mytheme.dart';
import 'package:td3/UI/home.dart';
import 'package:td3/ViewModel/setting_view_model.dart';
import 'package:td3/ViewModel/task_view_model.dart';

void main() {
  runApp(const MyTD3App());
}

class MyTD3App extends StatelessWidget {
  const MyTD3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            SettingViewModel settingViewModel = SettingViewModel();
            return settingViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            TaskViewModel taskViewModel = TaskViewModel();
            taskViewModel.generateTasks();
            return taskViewModel;
          },
        ),
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, vm, _) {
          return MaterialApp(
            title: 'TD3',
            theme: vm.isDark ? MyTheme.dark() : MyTheme.light(),
            home: const Home(),
          );
        },
      ),
    );
  }
}
