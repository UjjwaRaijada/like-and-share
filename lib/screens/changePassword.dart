import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth.dart';
import '../providers/myProfile.dart';
import '../widgets/startingCode.dart';
import '../widgets/textFormBorder.dart';
import '../widgets/alertBox.dart';

class ChangePassword extends StatefulWidget {
  static const String id = 'ChangePassword';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _spinner = false;
  FocusNode _oldPasswordFocus = FocusNode();
  FocusNode _newPasswordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();
  String _oldPassword;
  String _newPassword;
  String _confirmPassword;
  int id;

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_spinner == true) {
      Provider.of<MyProfileData>(context, listen: false)
          .refreshData()
          .then((value) {
        setState(() {
          _spinner = false;
        });
        if (value == 200) {
          id = Provider.of<MyProfileData>(context, listen: false).data.id;
        } else if (value == 401) {
          _logoutUser(context);
        } else {
          return showDialog(
              context: context,
              builder: (ctx) => AlertBox(
                onPress: () => Navigator.pop(context),
              )
          ).then((_) {
            Navigator.pop(context);
          });
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
    super.didChangeDependencies();
  }

  void _logoutUser(BuildContext context) async {
    Navigator.pop(context);
    Provider.of<Auth>(context, listen: false).logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
  }

  @override
  void dispose() {
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  /// change password
  void _submit() {
    setState(() {
      _spinner = true;
    });
    print('old :::::::::::::: $_oldPassword');
    print('new :::::::::::::: $_newPassword');
    print('confirm ::::::::::::: $_confirmPassword');
    if (_newPassword != _confirmPassword) {
      setState(() {
        _spinner = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertBox(
          body: 'There is a mismatch in your new password.',
          onPress: () => Navigator.pop(context),
        ),
      );
    } else {
      Provider.of<MyProfileData>(context, listen: false)
          .changePassword(_oldPassword, _newPassword)
          .then((value) {
        if (value == true) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) =>
              AlertBox(
                title: 'Superrrrb!',
                body: 'Your password was changed successfully.',
                onPress: () =>
                  Navigator.pushReplacementNamed(context, '/'),
              ),
          );
        } else {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) =>
              AlertBox(
                body: 'You entered wrong password.',
                onPress: () => Navigator.pop(context),
              ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'You are Awesome',
      widget: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                height: 180,
                child: Image.asset('assets/images/logo.png', fit: BoxFit.contain,),
              ),
              Column(
                children: [
                  ProfileTile(
                    title: 'Old Password',
                    save: (val) => _oldPassword = val,
                    fieldSubmit: (_) =>
                        FocusScope.of(context).requestFocus(_newPasswordFocus),
                  ),
                  ProfileTile(
                    title: 'New Password',
                    save: (val) => _newPassword = val,
                    focusName: _newPasswordFocus,
                    fieldSubmit: (_) =>
                        FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                  ),
                  ProfileTile(
                    title: 'Retype New Password',
                    save: (val) => _confirmPassword = val,
                    focusName: _confirmPasswordFocus,
                    fieldSubmit: (_) => _submit(),
                  ),
                  const SizedBox(height: 30),
                  _spinner == true
                    ? CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)
                    : ElevatedButton(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final FocusNode focusName;
  final Function save;
  final Function fieldSubmit;

  const ProfileTile({
    this.title,
    this.focusName,
    this.save,
    this.fieldSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: title,
          border: textFormBorder(context),
          enabledBorder: textFormBorder(context),
        ),
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        onChanged: save,
        focusNode: focusName,
        onFieldSubmitted: fieldSubmit,
      ),
    );
  }
}
