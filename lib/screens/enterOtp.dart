import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import './register.dart';
import './resetPassword.dart';
import '../providers/otp.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/otpBox.dart';

class EnterOtp extends StatefulWidget {
  static const String id = 'EnterOtp';

  @override
  _EnterOtpState createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final _form = GlobalKey<FormState>();
  bool _spinner;
  String _firstInt;
  String _secondInt;
  String _thirdInt;
  String _forthInt;
  int otp;
  final _secondFocus = FocusNode();
  final _thirdFocus = FocusNode();
  final _forthFocus = FocusNode();

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
    setState(() {
      _spinner = true;
    });
    otp = int.parse(_firstInt+_secondInt+_thirdInt+_forthInt);

    Provider.of<OtpData>(context, listen: false).enterOtp(otp).then((value) {
      if (value == true) {
        setState(() {
          _spinner = false;
        });
        Navigator.pushReplacementNamed(context, ResetPassword.id);
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation1, animation2) => ResetPassword(),
        //     transitionDuration: Duration(seconds: 0),
        //   ),
        // );
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

  @override
  Widget build(BuildContext context) {
    int pass;

    return LoginLogoCode(
      title: 'ENTER OTP',
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),
    );
  }
}
