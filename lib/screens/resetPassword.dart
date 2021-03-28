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
  final _form = GlobalKey<FormState>();
  final _retypeFocusNode = FocusNode();
  String? password;
  bool? _spinner;

  @override
  void dispose() {
    _retypeFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _spinner = true;
    });
    Provider.of<OtpData>(context, listen: false)
        .resetPassword(password)
        .then((value) {
      if (value == true) {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            title: 'Superrrrb!',
            body: 'Your password was changed successfully.',
            onPress: () => Navigator.pushReplacementNamed(context, Login.id),
          ),
        ).then((value) => Navigator.pushReplacementNamed(context, Login.id));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginLogoCode(
      title: 'RESET PASSWORD',
      widget: Form(
        key: _form,
        child: Column(
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
                if (val!.isEmpty) {
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
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
