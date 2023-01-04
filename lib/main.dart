import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soil_level_monitor_app/presentation/controller.dart';
import 'package:soil_level_monitor_app/presentation/view.dart';
import 'package:soil_level_monitor_app/services/background_services.dart';
import 'package:soil_level_monitor_app/services/local_notif_services.dart';
import 'package:soil_level_monitor_app/soil_level_monitor_app.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  LocalNotificationServices localNotificationServices =
      LocalNotificationServices();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // AndroidInitializationSettings('@mipmap/ic');

  // ignore: prefer_const_constructors
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  localNotificationServices.initializeNotificationServices();
  BackgroundService backgroundService = BackgroundService();
  backgroundService.initializeBackgroundService();
  final controller = Get.put(SoilMostureController());
  controller.mqttConnect();
  runApp(const SoilMoistureApp());
}
