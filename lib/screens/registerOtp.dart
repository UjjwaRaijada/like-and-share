import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/otpBox.dart';

class RegisterOtp extends StatefulWidget {
  static const String id = 'RegisterOtp';

  @override
  _RegisterOtpState createState() => _RegisterOtpState();
}

class _RegisterOtpState extends State<RegisterOtp> {
  final _form = GlobalKey<FormState>();
  bool _spinner;

  @override
  Widget build(BuildContext context) {
    int _id = ModalRoute.of(context).settings.arguments;
    String _firstInt;
    String _secondInt;
    String _thirdInt;
    String _forthInt;
    int otp;
    final _secondFocus = FocusNode();
    final _thirdFocus = FocusNode();
    final _forthFocus = FocusNode();


    void resendOtp() {
      setState(() {
        _spinner = true;
      });
      Provider.of<Auth>(context, listen: false).resendOtp(_id).then((value) {
        if (value == true) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertBox(
              title: 'Done!',
              body: 'We have sent a new OTP at your registered email id.',
              onPress: () => Navigator.pop(context),
            ),
          );
        } else {
          setState(() {
            _spinner = false;
          });
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


    void _submit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();

      setState(() {
        _spinner = true;
      });

      otp = int.parse(_firstInt+_secondInt+_thirdInt+_forthInt);

      Provider.of<Auth>(context, listen: false).registerOtp(otp, _id).then((value) {
        if (value == true) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertBox(
              title: 'Congratulations!!',
              body: 'Welcome to Like & Share! We wish you lots of fame and name. Promote your Social Media pages for free and get famous!',
              onPress: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ).then((value) => Navigator.pushReplacementNamed(context, '/'),);
        } else {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertBox(
              body: 'You have entered the wrong OTP. Please try again.',
              onPress: () => Navigator.pop(context),
            ),
          );
        }
      });
    }


    return LoginLogoCode(
      title: 'ENTER OTP',
      widget: Column(
        children: [
          Form(
            key: _form,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                otpBox(
                  context: context,
                  onChange: (value) {
                    if(_firstInt == null) {
                      FocusScope.of(context).requestFocus(_secondFocus);
                    }
                    _firstInt = value;
                  },
                ),
                otpBox(
                  context: context,
                  focus: _secondFocus,
                  onChange: (value) {
                    if(_secondInt == null) {
                      FocusScope.of(context).requestFocus(_thirdFocus);
                    }
                    _secondInt = value;
                  },
                ),
                otpBox(
                  context: context,
                  focus: _thirdFocus,
                  onChange: (value) {
                    if(_thirdInt == null) {
                      FocusScope.of(context).requestFocus(_forthFocus);
                    }
                    _thirdInt = value;
                  },
                ),
                otpBox(
                  context: context,
                  focus: _forthFocus,
                  onChange: (value) {
                    _forthInt = value;
                  },
                ),
              ],
            ),
          ),
          _spinner == true
          ? CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          )
          : Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                ),
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => resendOtp(),
                child: Text(
                  'Resend OTP',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}