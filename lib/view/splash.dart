import 'package:flutter/material.dart';
import 'package:flutter_youtube_video/view/home_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((value) => Get.offAll(
        const HomeScreen(),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        transition: Transition.fade));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      'assets/youtube.png',
      width: 200,
      color: Colors.white70,
    ));
  }
}
