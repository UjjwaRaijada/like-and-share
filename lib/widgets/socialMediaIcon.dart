import 'package:flutter/material.dart';

class SocialMediaIcon extends StatelessWidget {
  final Function onPress;
  final String iconUrl;

  SocialMediaIcon({this.onPress, this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      child: RawMaterialButton(
        onPressed: onPress,
        // splashColor: Colors.green,
        shape: const CircleBorder(),
        child: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              // gradient: const LinearGradient(
              //   colors: [Color(0xFFF3F9A7), Color(0xFFCAC531)],
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              // ),
              color: Color(0xFFffe485),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 2.0, //extend the shadow
                  offset: const Offset(
                    0, // Move to right 10  horizontally
                    2.0, // Move to bottom 5 Vertically
                  ),
                ),
              ]),
          child: Image.asset(
            iconUrl,
          ),
        ),
      ),
    );
  }
}
