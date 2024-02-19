import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:assignment/dashboard/dashboard.dart';
import 'package:flutter/material.dart';


class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/logo.png'), // Replace with your splash image
        splashIconSize: double.infinity,
        nextScreen: Dashboard(),
        splashTransition: SplashTransition.sizeTransition,

        duration: 500, // Adjust the duration as needed (milliseconds)
      ),
    );
  }
}
