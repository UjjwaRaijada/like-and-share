import 'package:flutter/material.dart';

class LoginLogoCode extends StatelessWidget {
  final Widget widget;
  final Widget bottomSheet;

  LoginLogoCode({this.widget, this.bottomSheet});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 28, right: 28),
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF150029), Color(0xFF0B0014)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 50),
              widget,
            ],
          ),
        ),
      ),
      bottomSheet: bottomSheet,
    );
  }
}
