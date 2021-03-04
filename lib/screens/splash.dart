import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static const String id = 'Splash';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // void initState() {
  //   startTimer();
  //
  //   super.initState();
  // }

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

  // void startTimer() {
  //   Timer(Duration(seconds: 1), () {
  //     navigateUser(); //It will redirect  after 3 seconds
  //   });
  // }
  //
  // void navigateUser() async {
  //   Provider.of<Auth>(context, listen: false).autoLogin().then((value) {
  //     if (value) {
  //       Navigator.pushReplacementNamed(context, Home.id);
  //     } else {
  //       Navigator.pushReplacementNamed(context, Login.id);
  //     }
  //   });

  // final prefs = await SharedPreferences.getInstance();
  // final _extractedUserData = jsonDecode(prefs.getString('userData'));
  //
  // print('token :::::::: ${_extractedUserData['token']}');
  // print('userId :::::::: ${_extractedUserData['userId']}');

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  // var status = prefs.getBool('isLoggedIn') ?? false;
  // print(status);
  // if (status) {
  //   Navigator.pushReplacementNamed(context, Home.id);
  // } else {
  //   Navigator.pushReplacementNamed(context, Login.id);
  // }
  // }
}
