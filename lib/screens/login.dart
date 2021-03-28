// import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import './register.dart';
import './forgotPassword.dart';
import './registerOtp.dart';
import '../providers/auth.dart';
// import '../providers/myProfile.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class User {
  final String? name;
  final String? username;
  final String? password;

  User({
    this.name,
    this.username,
    this.password,
  });
}

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'profile',
//   ],
// );

class Login extends StatefulWidget {
  static const String id = 'Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _spinner = false;
  final _passwordFocusNode = FocusNode();
  User signingUser = User(name: '', username: '', password: '');
  final _form = GlobalKey<FormState>();

  /// ANDROID GOOGLE LOGIN
  // Future<void> _handleSignIn() async {
  //   setState(() {
  //     _spinner = true;
  //   });
  //   try {
  //     final result = await _googleSignIn.signIn();
  //     if(result.id.isEmpty || result.email.isEmpty) {
  //       return showDialog(
  //         context: context,
  //         builder: (context) => AlertBox(
  //           onPress: () => Navigator.of(context),
  //         ),
  //       );
  //     } else {
  //       signingUser = User(
  //         name: result.displayName,
  //         username: result.email,
  //         password: result.id,
  //       );
  //       Provider.of<Auth>(context, listen: false)
  //         .googleAuthenticate(signingUser.username)
  //         .then((value) async {
  //           if (value == true) {
  //             setState(() {
  //               _spinner = false;
  //             });
  //             Navigator.pushReplacementNamed(context, '/');
  //           } else {
  //             MyProfile newProfile = MyProfile(
  //               name: result.displayName,
  //               email: result.email,
  //               password: result.id,
  //             );
  //             Provider.of<MyProfileData>(context, listen: false)
  //               .googleRegister(newProfile)
  //               .then((value) {
  //                 String _msg = Provider.of<MyProfileData>(context, listen: false).msg;
  //                 if (value == 201) {
  //                   Provider.of<Auth>(context, listen: false)
  //                       .authenticate(signingUser.username, signingUser.password)
  //                       .then((value) async {
  //                     if (value == true) {
  //                       setState(() {
  //                         _spinner = false;
  //                       });
  //                       Navigator.pushReplacementNamed(context, '/');
  //                     } else {
  //                       setState(() {
  //                         _spinner = false;
  //                       });
  //                       return showDialog(
  //                         context: context,
  //                         builder: (ctx) => AlertBox(
  //                           onPress: () => Navigator.pop(context),
  //                         ),
  //                       );
  //                     }
  //                   });
  //                 } else if (value == 400) {
  //                   setState(() {
  //                     _spinner = false;
  //                   });
  //                   return showDialog(
  //                     context: context,
  //                     builder: (ctx) => AlertBox(
  //                       title: 'Please check!',
  //                       body: _msg,
  //                       onPress: () => Navigator.pop(context),
  //                     ),
  //                   );
  //                 } else {
  //                   setState(() {
  //                     _spinner = false;
  //                   });
  //                   return showDialog(
  //                     context: context,
  //                     builder: (ctx) => AlertBox(
  //                       onPress: () => Navigator.pop(context),
  //                     ),
  //                   );
  //                 }
  //             });
  //           }
  //       }).catchError((error) {
  //         setState(() {
  //           _spinner = false;
  //         });
  //         return showDialog(
  //           context: context,
  //           builder: (ctx) => AlertBox(
  //             onPress: () => Navigator.pop(context),
  //           ),
  //         );
  //       });
  //     }
  //     print('People API $result');
  //   } catch (error) {
  //     print(error);
  //   }
  // }



  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

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

    Provider.of<Auth>(context, listen: false)
        .authenticate(signingUser.username, signingUser.password)
        .then((value) async {
      if (value == 200) {
        setState(() {
          _spinner = false;
        });
        // Navigator.pushReplacementNamed(context, Home.id);
        Navigator.pushReplacementNamed(context, '/');
      } else if (value == 403) {
        int? _myId = Provider.of<Auth>(context, listen: false).userId;
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            title: 'Verify Email ID',
            body: 'We have sent you OTP on your registered email address.',
            onPress: () =>  Navigator.pushReplacementNamed(context, RegisterOtp.id, arguments: _myId),
          ),
        ).then((_) =>
            Navigator.pushReplacementNamed(context, RegisterOtp.id, arguments: _myId),
        );
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
      title: 'LOGIN',
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
                if (val!.isEmpty) {
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
                if (value!.isEmpty) {
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
              ? CircularProgressIndicator(
                // valueColor:
                //     AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                backgroundColor: Theme.of(context).primaryColor,
              )
              : ElevatedButton(
                onPressed: _submit,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                ),
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            const SizedBox(height: 10),
            /// GOOGLE LOGIN ANDROID
            // Platform.isAndroid
            //   ? ElevatedButton(
            //       onPressed: _handleSignIn,
            //       style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
            //       ),
            //       child: Container(
            //         width: 180,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               'Login with Google',
            //               style: Theme.of(context).textTheme.button.copyWith(color: Colors.black),
            //             ),
            //             Container(
            //               height: 20,
            //               width: 20,
            //               child: Image.asset('assets/images/google.png', fit: BoxFit.cover,),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //   : SizedBox(height: 0),
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
