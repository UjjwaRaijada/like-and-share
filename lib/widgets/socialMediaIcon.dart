import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaIcon extends StatelessWidget {
  final Function? onPress;
  final IconData? icon;
  final Color iconColor;

  SocialMediaIcon({
    this.onPress,
    this.icon,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      child: RawMaterialButton(
        onPressed: onPress as void Function()?,
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
          child: Center(
            child: FaIcon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SocialMediaInfo extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;

  SocialMediaInfo({
    this.icon,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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
        child: Center(
          child: FaIcon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
