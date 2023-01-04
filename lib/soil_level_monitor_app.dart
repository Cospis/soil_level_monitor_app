// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soil_level_monitor_app/presentation/view.dart';

class SoilMoistureApp extends StatelessWidget {
  const SoilMoistureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Soil Moisture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SoilMoisturePageView(),
      // home: const AnimatedApp(),
    );
  }
}
