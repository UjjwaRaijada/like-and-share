import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import './register.dart';
import './resetPassword.dart';
import '../providers/otp.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class EnterOtp extends StatelessWidget {
  static const String id = 'EnterOtp';

  void resendOtp(context) {
    Provider.of<OtpData>(context, listen: false).resendOtp().then((value) {
      if (value == true) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            title: 'Done!',
            body: 'We have sent a new OTP at your registered email id.',
            onPress: () => Navigator.pop(context),
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            onPress: () => Navigator.pop(context),
          ),
        );
      }
    }).catchError((error) {
      throw error;
    });
  }

  void _submit(context, pass) async {
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
          builder: (ctx) => AlertBox(
            title: 'Oopsss!',
            body: 'You have entered the wrong OTP. Please try again.',
            onPress: () => Navigator.pop(context),
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
              border: textFormBorder(context),
              enabledBorder: textFormBorder(context),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => pass = int.parse(value),
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _submit(context, pass),
          ),
          const SizedBox(height: 45),
          ElevatedButton(
            onPressed: () {
              _submit(context, pass);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
            ),
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          const SizedBox(height: 25),
          Container(
            height: 50,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.button,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => resendOtp(context),
                    child: const Text(
                      'Resend OTP',
                    ),
                  ),
                  const Text(
                    '|',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              Login(),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign In',
                    ),
                  ),
                  const Text(
                    '|',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              Register(),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
