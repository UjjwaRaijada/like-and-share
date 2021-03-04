import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import './register.dart';
import './resetPassword.dart';
import '../providers/otp.dart';
import '../widgets/loginLogoCode.dart';

class EnterOtp extends StatelessWidget {
  static const String id = 'EnterOtp';

  void resendOtp(context) {
    Provider.of<OtpData>(context, listen: false).resendOtp().then((value) {
      if (value == true) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Done!'),
            content:
                Text('We have sent a new OTP at your registered email id.'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Oooopppsssss!'),
            content: Text('Something went wrong. Please try again.'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    }).catchError((error) {
      print('enterOtp.dart :: error :::::::::: $error');
    });
  }

  void _submit(context, pass) async {
    print('enterOtp.dart :: pass :::::::: $pass');
    Provider.of<OtpData>(context, listen: false).enterOtp(pass).then((value) {
      if (value == true) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ResetPassword(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Oooopppsssss!'),
            content: Text('You have entered the wrong OTP. Please try again.'),
            actions: [
              FlatButton(
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
    int pass;

    return LoginLogoCode(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Enter OTP (sent on your registered email)',
              labelStyle: TextStyle(color: Colors.white),
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
            keyboardType: TextInputType.number,
            onChanged: (value) => pass = int.parse(value),
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _submit(context, pass),
          ),
          SizedBox(height: 45),
          RaisedButton(
            onPressed: () {
              _submit(context, pass);
            },
            color: Colors.pinkAccent,
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          SizedBox(height: 25),
          Container(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  onPressed: () => resendOtp(context),
                  child: Text(
                    'Resend OTP',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                Text(
                  '|',
                  style: Theme.of(context).textTheme.button,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Login(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                Text(
                  '|',
                  style: Theme.of(context).textTheme.button,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Register(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  },
                  child: Text(
                    'Register',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
