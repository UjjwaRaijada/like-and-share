import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import '../providers/myProfile.dart';
import '../widgets/loginLogoCode.dart';

class Register extends StatefulWidget {
  static const String id = 'Register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _spinner = false;
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _refByFocusNode = FocusNode();
  MyProfile _register = MyProfile(
    name: '',
    email: '',
    mobile: 0,
    password: '',
    refBy: 0,
  );

  String temp;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _refByController = TextEditingController();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    _refByFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _refByController.dispose();
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

    Provider.of<MyProfileData>(context, listen: false)
        .register(_register)
        .then((value) {
      String _msg = Provider.of<MyProfileData>(context, listen: false).msg;

      if (value == 201) {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Congratulations!!'),
            content: Text(_msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        ).then((_) => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Login(),
                transitionDuration: Duration(seconds: 0),
              ),
            ));
      } else if (value == 400) {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Please check!'),
            content: Text(_msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An Error Occurred!'),
            content: const Text('Something went wrong. Please try again.'),
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
      widget: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              title: 'Name',
              teController: _nameController,
              nextFocus: (_) =>
                  FocusScope.of(context).requestFocus(_emailFocusNode),
              onSave: (newValue) {
                _register = MyProfile(
                  name: newValue,
                  email: _register.email,
                  mobile: _register.mobile,
                  password: _register.password,
                  refBy: _register.refBy,
                );
              },
              onValidate: (val) {
                if (val.isEmpty) {
                  return 'Please enter your Name';
                }
                return null;
              },
            ),
            CustomTextField(
              title: 'Email Id',
              teController: _emailController,
              keyboard: TextInputType.emailAddress,
              fNode: _emailFocusNode,
              nextFocus: (_) =>
                  FocusScope.of(context).requestFocus(_mobileFocusNode),
              onSave: (newValue) {
                _register = MyProfile(
                  name: _register.name,
                  email: newValue,
                  mobile: _register.mobile,
                  password: _register.password,
                  refBy: _register.refBy,
                );
              },
              onValidate: (val) {
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
            ),
            CustomTextField(
              title: 'Mobile No.',
              keyboard: TextInputType.number,
              teController: _mobileController,
              fNode: _mobileFocusNode,
              nextFocus: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocusNode),
              onSave: (newValue) {
                _register = MyProfile(
                  name: _register.name,
                  email: _register.email,
                  mobile: int.parse(newValue),
                  password: _register.password,
                  refBy: _register.refBy,
                );
              },
              onValidate: (val) {
                if (val.isEmpty) {
                  return 'Please enter your Mobile No';
                }
                return null;
              },
            ),
            CustomTextField(
              title: 'Password',
              teController: _passwordController,
              fNode: _passwordFocusNode,
              password: true,
              nextFocus: (_) =>
                  FocusScope.of(context).requestFocus(_refByFocusNode),
              onSave: (newValue) {
                _register = MyProfile(
                  name: _register.name,
                  email: _register.email,
                  mobile: _register.mobile,
                  password: newValue,
                  refBy: _register.refBy,
                );
              },
              onValidate: (val) {
                if (val.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            CustomTextField(
              title: 'Referral Code',
              keyboard: TextInputType.number,
              teController: _refByController,
              fNode: _refByFocusNode,
              nextFocus: (_) => _submit(),
              onSave: (newValue) {
                String val =
                    newValue == null || newValue == "" ? '0' : newValue;
                _register = MyProfile(
                  name: _register.name,
                  email: _register.email,
                  mobile: _register.mobile,
                  password: _register.password,
                  refBy: int.parse(val),
                );
              },
            ),
            const SizedBox(height: 30),
            _spinner == true
                ? Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                : SizedBox(height: 0),
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
            Container(
              height: 20,
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
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String title;
  final TextInputType keyboard;
  final TextEditingController teController;
  final FocusNode fNode;
  final Function onSave;
  final Function onValidate;
  final Function nextFocus;
  final bool password;

  CustomTextField({
    this.title,
    this.keyboard = TextInputType.text,
    this.teController,
    this.fNode,
    this.onSave,
    this.onValidate,
    this.nextFocus,
    this.password = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: title,
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          enableSuggestions: false,
          autocorrect: false,
          cursorColor: Theme.of(context).primaryColor,
          obscureText: password,
          validator: onValidate,
          controller: teController,
          focusNode: fNode,
          keyboardType: keyboard,
          onSaved: onSave,
          onFieldSubmitted: nextFocus,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
