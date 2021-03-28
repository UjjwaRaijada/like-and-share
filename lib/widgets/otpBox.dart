import 'package:flutter/material.dart';

Widget otpBox({
  required BuildContext context,
  Function? onChange,
  FocusNode? focus,
}) {
  return Container(
    height: 100,
    width: 35,
    child:TextFormField(
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
      maxLength: 1,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      focusNode: focus,
      onChanged: onChange as void Function(String)?,
      validator:  (value) {
        if(value!.isEmpty) {
          return '?';
        }
        return null;
      },
    ),
  );
}