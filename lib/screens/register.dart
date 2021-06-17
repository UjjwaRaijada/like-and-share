import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './login.dart';
import './registerOtp.dart';
import '../providers/myProfile.dart';
import '../widgets/loginLogoCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

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
    id: 0,
    name: '',
    email: '',
    mobile: 0,
    password: '',
    refBy: 0,
  );

  String? temp;
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
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _spinner = true;
    });

    Provider.of<MyProfileData>(context, listen: false)
        .register(_register)
        .then((value) {
      String? _msg = Provider.of<MyProfileData>(context, listen: false).msg;
      MyProfile _myProfile = Provider.of<MyProfileData>(context, listen: false).data;

      if (value == 201) {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            title: 'OTP Required!',
            body: 'We have sent you OTP on your registered email address.',
            onPress: () =>  Navigator.pushReplacementNamed(context, RegisterOtp.id, arguments: _myProfile.id),
          ),
        ).then((_) =>
            Navigator.pushReplacementNamed(context, RegisterOtp.id, arguments: _myProfile.id),
        );
      } else if (value == 400) {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            title: 'Please check!',
            body: _msg,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginLogoCode(
      title: 'REGISTER',
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
                  id: 0,
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
                  id: 0,
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
            NumberField(
              title: 'Mobile No.',
              teController: _mobileController,
              fNode: _mobileFocusNode,
              nextFocus: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocusNode),
              onSave: (newValue) {
                _register = MyProfile(
                  id: 0,
                  name: _register.name,
                  email: _register.email,
                  mobile: int.parse(newValue),
                  password: _register.password,
                  refBy: _register.refBy,
                );
              },
              inputFormat: FilteringTextInputFormatter.allow(RegExp("[0-9]")),
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
                  id: 0,
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
            NumberField(
              title: 'Referral Code (if any)',
              teController: _refByController,
              fNode: _refByFocusNode,
              nextFocus: (_) => _submit(),
              inputFormat: FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              onSave: (newValue) {
                String val =
                newValue == null || newValue == "" ? '0' : newValue;
                _register = MyProfile(
                  id: 0,
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
                ? CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            )
                : ElevatedButton(
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
                child: Text(
                  'Sign In',
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
  final String? title;
  final TextInputType keyboard;
  final TextEditingController? teController;
  final FocusNode? fNode;
  final Function? onSave;
  final Function? onValidate;
  final Function? nextFocus;
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
            border: textFormBorder(context),
            enabledBorder: textFormBorder(context),
          ),
          enableSuggestions: false,
          autocorrect: false,
          cursorColor: Theme.of(context).primaryColor,
          obscureText: password,
          validator: onValidate as String? Function(String?)?,
          controller: teController,
          focusNode: fNode,
          keyboardType: keyboard,
          onSaved: onSave as void Function(String?)?,
          onFieldSubmitted: nextFocus as void Function(String)?,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class NumberField extends StatelessWidget {
  final String? title;
  final TextEditingController? teController;
  final FocusNode? fNode;
  final Function? onSave;
  final Function? onValidate;
  final Function? nextFocus;
  final TextInputFormatter? inputFormat;

  NumberField({
    this.title,
    this.teController,
    this.fNode,
    this.onSave,
    this.onValidate,
    this.nextFocus,
    this.inputFormat,
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
            border: textFormBorder(context),
            enabledBorder: textFormBorder(context),
          ),
          cursorColor: Theme.of(context).primaryColor,
          validator: onValidate as String? Function(String?)?,
          controller: teController,
          focusNode: fNode,
          keyboardType: TextInputType.number,
          onSaved: onSave as void Function(String?)?,
          onFieldSubmitted: nextFocus as void Function(String)?,
          inputFormatters: [inputFormat!],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
