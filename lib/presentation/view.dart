// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soil_level_monitor_app/presentation/controller.dart';

class SoilMoisturePageView extends StatefulWidget {
  const SoilMoisturePageView({super.key});

  @override
  State<SoilMoisturePageView> createState() => _SoilMoisturePageViewState();
}

class _SoilMoisturePageViewState extends State<SoilMoisturePageView> {
  final controller = Get.put(SoilMostureController());

  Timer? timer;

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(
    //     const Duration(seconds: 5), (Timer t) => controller.generateRandom());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Soil Mosture Monitor',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: size.height * 0.1,
              width: size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/soil_grass_top-transformed.jpeg',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          GetBuilder<SoilMostureController>(
            init: SoilMostureController(),
            builder: (context) {
              return Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: size.height * 0.8,
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/soil-image-transformed.jpeg',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: size.height * 0.8,
                    //   width: size.width * 0.12,
                    //   child: Column(
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           width: size.width * 0.12,
                    //           height: size.height *
                    //               0.8 *
                    //               (100.0 -
                    //                   controller.percentageVal.toDouble() /
                    //                       100),
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       Container(
                    //         width: size.width * 0.12,
                    //         height: size.height *
                    //             0.8 *
                    //             (controller.percentageVal.toDouble() / 100),
                    //         color: Colors.blue[100],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Positioned(
                      child: Column(
                        children: [
                          Text(
                            '${controller.percentageVal}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'Soil moisture',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
