import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import '../providers/otp.dart';
import '../widgets/loginLogoCode.dart';

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
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text('Something went wrong. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
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
            decoration: const InputDecoration(
              labelText: 'New Password',
              labelStyle: const TextStyle(color: Colors.white),
              border: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              ),
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
          SizedBox(height: 15),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Retype Password',
              labelStyle: const TextStyle(color: Colors.white),
              border: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              ),
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
          SizedBox(height: 25),
          Container(
            height: 15,
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
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
