import 'package:flutter/material.dart';

class HalfRow extends StatelessWidget {
  final String? title;
  HalfRow({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          title!,
        ),
      ),
    );
  }
}
