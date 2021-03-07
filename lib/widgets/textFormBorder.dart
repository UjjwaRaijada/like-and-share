import 'package:flutter/material.dart';

OutlineInputBorder textFormBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(
      color: Theme.of(context).primaryColor,
      width: 2.0,
    ),
  );
}
