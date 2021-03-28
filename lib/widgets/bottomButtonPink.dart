import 'package:flutter/material.dart';

class BottomButtonPink extends StatelessWidget {
  final Function? onPress;
  final IconData? icon;
  final String? label;
  BottomButtonPink({
    this.onPress,
    this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        maxHeight: 45,
        minHeight: 45,
      ),
      onPressed: onPress as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 25,
            ),
            const SizedBox(height: 3),
            Text(
              label!,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
