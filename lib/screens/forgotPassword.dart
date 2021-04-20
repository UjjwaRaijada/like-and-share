import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import './register.dart';
import './enterOtp.dart';
import '../providers/otp.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = 'ForgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _form = GlobalKey<FormState>();
  bool _spinner = false;
  String? email;
  String? msg;

  void _submit() async {
    ///necessary code for saving the form
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _spinner = true;
    });
    if (_spinner == true) {
      Provider.of<OtpData>(context, listen: false)
          .forgotPassword(email)
          .then((value) {
        if (value == false) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertBox(
              body: 'This email id is not registered! Don\'t miss out on the opportunity to get free publicity and promotion of your social media pages!',
              onPress: () => Navigator.pop(context),
            ),
          );
        } else {
          setState(() {
            _spinner = true;
          });
          return showDialog(
            context: context,
            builder: (context) => AlertBox(
              title: 'OTP Sent!',
              body: 'We have sent you an OTP at your registered email address.',
              onPress: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => EnterOtp(),
                  transitionDuration: Duration(seconds: 0),
                ),
              ),
            ),
          ).then((value) => PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => EnterOtp(),
            transitionDuration: Duration(seconds: 0),
          ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginLogoCode(
      title: 'FORGOT PASSWORD',
      widget: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email Id',
                labelStyle: const TextStyle(color: Colors.white),
                border: textFormBorder(context),
                enabledBorder: textFormBorder(context),
              ),
              validator: (val) {
                var urlPattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                var result =
                RegExp(urlPattern, caseSensitive: false).hasMatch(val!);
                if (val.isEmpty) {
                  return 'Please enter your Email Id';
                }
                if (!result) {
                  return 'Email Id entered is incorrect';
                }
                return null;
              },
              enableSuggestions: false,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _submit(),
              onSaved: (newValue) => email = newValue,
              controller: TextEditingController(text: email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 45),
            _spinner == true
                ? CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor)
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
                const SizedBox(height: 25),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
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
                        child: const Text(
                          'Sign In',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '|',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                      TextButton(
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
                        child: const Text(
                          'Register',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
