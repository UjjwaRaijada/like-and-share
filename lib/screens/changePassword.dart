import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/myProfile.dart';
import '../widgets/startingCode.dart';

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
        if (value == true) {
          id = Provider.of<MyProfileData>(context, listen: false).data.id;
        } else {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text('Something went wrong. Please try again.'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ],
            ),
          );
        }
      }).catchError((error) {
        setState(() {
          _spinner = false;
        });
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text('Something went wrong. Please try again.'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      });
    }
    super.didChangeDependencies();
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
    Provider.of<MyProfileData>(context, listen: false)
        .changePassword(_oldPassword, _newPassword)
        .then((value) {
      if (value == true) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Superb!'),
            content: Text('Your password was changed successfully.'),
            actions: [
              FlatButton(
                onPressed: () =>
                    // Navigator.pushReplacementNamed(context, Home.id),
                    Navigator.pushReplacementNamed(context, '/'),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Oooppssssss!'),
            content: Text('You entered wrong password.'),
            actions: [
              FlatButton(
                onPressed: () =>
                    // Navigator.pushReplacementNamed(context, Home.id),
                    Navigator.pushReplacementNamed(context, '/'),
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
    return StartingCode(
      title: 'You are Awesome',
      widget: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          height: 400,
          child: Column(
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
                save: (val) => _confirmPassword,
                focusName: _confirmPasswordFocus,
                fieldSubmit: (_) => _submit(),
              ),
              const SizedBox(height: 30),
              RaisedButton(
                onPressed: () {
                  _submit();
                },
                color: Colors.pinkAccent,
                child: const Text(
                  'Submit',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
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
        decoration: InputDecoration(labelText: title),
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
