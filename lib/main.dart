import 'package:flutter/material.dart';
import 'package:flutter_youtube_video/controller/video_controller.dart';
import 'package:flutter_youtube_video/view/splash.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VideoController());
    return GetMaterialApp(
      title: 'Flutter Youtube',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
