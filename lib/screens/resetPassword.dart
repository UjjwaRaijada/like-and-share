import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import '../providers/otp.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'ResetPassword';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _retypeFocusNode = FocusNode();
  String password;

  @override
  void dispose() {
    _retypeFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    Provider.of<OtpData>(context, listen: false)
        .resetPassword(password)
        .then((value) {
      if (value == true) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Login(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
        Navigator.pushReplacementNamed(context, Login.id);
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            onPress: () => Navigator.pop(context),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginLogoCode(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: const TextStyle(color: Colors.white),
              border: textFormBorder(context),
              enabledBorder: textFormBorder(context),
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (val) => password = val,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_retypeFocusNode),
          ),
          const SizedBox(height: 15),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration:  InputDecoration(
              labelText: 'Retype Password',
              labelStyle: const TextStyle(color: Colors.white),
              border: textFormBorder(context),
              enabledBorder: textFormBorder(context),
            ),
            validator: (val) {
              if (val != password) {
                return 'Password Mismatch';
              }
              return null;
            },
            focusNode: _retypeFocusNode,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 45),
          ElevatedButton(
            onPressed: () {
              _submit();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
            ),
            child: const Text(
              'Submit',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Login(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              child: const Text(
                'Sign In',
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
