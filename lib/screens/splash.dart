import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  static const String id = 'Splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
              image: const AssetImage("assets/images/splash.jpg"),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
