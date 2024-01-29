import 'dart:async';

import 'package:energy_tracker/firebase_options.dart';
import 'package:energy_tracker/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Timer(
        // const Duration(milliseconds: 5900),
        const Duration(milliseconds: 3500),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingPage())));
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  // 'assets/animations/colorful6.json', // Replace with the path to your Lottie JSON file
                  'assets/animations/pot.json', // Replace with the path to your Lottie JSON file
                  fit: BoxFit.cover,
                  width: 300, // Adjust the width and height as needed
                  height: 300,
                  repeat: true,
                  animate: true,
                  reverse: true,
                ),
              ),
            ],
          ),
        );
      },
      // child:
    );
  }
}
