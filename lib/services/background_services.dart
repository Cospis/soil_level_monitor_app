import 'package:flutter_background/flutter_background.dart';

class BackgroundService {
  final androidConfig = const FlutterBackgroundAndroidConfig(
    notificationTitle: "Soil Moisture Monitor",
    notificationText:
        "Soil Moisture Monitor app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );

  initializeBackgroundService() async {
    bool hasPermissions = await FlutterBackground.hasPermissions;
    bool initialized =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    bool enabledBackgroundExecution =
        await FlutterBackground.enableBackgroundExecution();
  }
}
