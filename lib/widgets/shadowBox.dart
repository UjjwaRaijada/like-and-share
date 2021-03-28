import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final Widget? widget;

  ShadowBox({this.widget});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: const Border.symmetric(
            vertical: BorderSide(
              width: 1,
              color: Colors.black26,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4.0, // soften the shadow
              // spreadRadius: 1.0, //extend the shadow
              offset: const Offset(
                2.0, // Move to right 10  horizontally
                2.0, // Move to bottom 5 Vertically
              ),
            ),
          ]),
      child: widget,
    );
  }
}
