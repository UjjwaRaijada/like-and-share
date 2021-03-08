import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './register.dart';
import './forgotPassword.dart';
import '../providers/auth.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class User {
  final String username;
  final String password;

  User({
    this.username,
    this.password,
  });
}

class Login extends StatefulWidget {
  static const String id = 'Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _spinner = false;
  final _passwordFocusNode = FocusNode();
  User signingUser = User(username: '', password: '');
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    ///necessary code for saving the form
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _spinner = true;
    });

    Provider.of<Auth>(context, listen: false)
        .authenticate(signingUser.username, signingUser.password)
        .then((value) async {
      if (value == true) {
        setState(() {
          _spinner = false;
        });
        // Navigator.pushReplacementNamed(context, Home.id);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            body: 'Wrong Email Id or Password. Please try again.',
            onPress: () => Navigator.pop(context),
          ),
        );
      }
    }).catchError((error) {
      setState(() {
        _spinner = false;
      });
      return showDialog(
        context: context,
        builder: (ctx) => AlertBox(
          onPress: () => Navigator.pop(context),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginLogoCode(
      widget: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email Id',
                labelStyle: const TextStyle(color: Colors.white),
                border: textFormBorder(context),
                enabledBorder: textFormBorder(context),
              ),
              enableSuggestions: false,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                var urlPattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                if (val.isEmpty) {
                  return 'Please enter your Email Id';
                }
                var result =
                    RegExp(urlPattern, caseSensitive: false).hasMatch(val);
                if (!result) {
                  return 'Email Id entered is incorrect';
                }
                return null;
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocusNode),
              onSaved: (newValue) {
                signingUser = User(
                  username: newValue,
                  password: signingUser.password,
                );
              },
              controller: TextEditingController(text: signingUser.username),
            ),
            const SizedBox(height: 15),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                border: textFormBorder(context),
                enabledBorder: textFormBorder(context),
              ),
              focusNode: _passwordFocusNode,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (newValue) {
                signingUser = User(
                  username: signingUser.username,
                  password: newValue,
                );
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 45),
            _spinner == true
                ? Center(
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                    ),
                  )
                : const SizedBox(height: 0),
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
                  TextButton(style: TextButton.styleFrom(),
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
                    child: const Text('Register'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('|',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              ForgotPassword(),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                    },
                    child: const Text('Forgot password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
