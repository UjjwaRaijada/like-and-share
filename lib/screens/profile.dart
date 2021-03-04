import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/myProfile.dart';
import '../widgets/startingCode.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _spinner = false;
  bool _onlyRead = true;
  FocusNode _cityFocus = FocusNode();
  FocusNode _facebookFocus = FocusNode();
  FocusNode _instagramFocus = FocusNode();
  FocusNode _twitterFocus = FocusNode();
  FocusNode _youtubeFocus = FocusNode();
  FocusNode _googleFocus = FocusNode();
  String _name;
  String _city;
  String _facebook;
  String _instagram;
  String _twitter;
  String _youtube;
  String _google;

  MyProfile _myProfile = MyProfile(
    id: 0,
    name: '',
    city: '',
    mobile: 0,
    email: '',
    password: '',
    hearts: 0,
  );

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
        if (value == true) {
          _myProfile = Provider.of<MyProfileData>(context, listen: false).data;
          _name = _myProfile.name;
          _city = _myProfile.city;
          _facebook = _myProfile.facebook;
          _instagram = _myProfile.instagram;
          _twitter = _myProfile.twitter;
          _youtube = _myProfile.youtube;
          _google = _myProfile.google;
          setState(() {
            _spinner = false;
          });
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
          ).then((_) {
            Navigator.pop(context);
          });
        }
      }).catchError((error) {
        print('profile.dart :: error ::::::::::: $error');
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
        ).then((_) {
          Navigator.pop(context);
        });
      }).then((_) {
        setState(() {
          _spinner = false;
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cityFocus.dispose();
    _facebookFocus.dispose();
    _instagramFocus.dispose();
    _twitterFocus.dispose();
    _youtubeFocus.dispose();
    _googleFocus.dispose();
    super.dispose();
  }

  void _saveProfile() {
    _myProfile = MyProfile(
      id: _myProfile.id,
      name: _name,
      city: _city,
      facebook: _facebook,
      instagram: _instagram,
      twitter: _twitter,
      youtube: _youtube,
      google: _google,
    );

    Provider.of<MyProfileData>(context, listen: false)
        .updateMyProfile(_myProfile)
        .then((value) {
      setState(() {
        _onlyRead = true;
      });
      if (value == true) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Hurrayyy!'),
            content: Text('Your profile data was successfully changed.'),
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
            title: Text('It is embarrassing!'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'You are Awesome',
      widget: _spinner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    ProfileTile(
                      title: 'Full Name',
                      initValue: _myProfile.name,
                      onlyRead: _onlyRead,
                      save: (val) => _name = val,
                      fieldSubmit: (_) =>
                          FocusScope.of(context).requestFocus(_cityFocus),
                    ),
                    ProfileTile(
                      title: 'City',
                      initValue: _myProfile.city,
                      onlyRead: _onlyRead,
                      save: (val) => _city = val,
                      fieldSubmit: (_) =>
                          FocusScope.of(context).requestFocus(_facebookFocus),
                    ),
                    ProfileTile(
                      title: 'Email Id',
                      initValue: _myProfile.email,
                    ),
                    ProfileTile(
                      title: 'Mobile',
                      initValue: _myProfile.mobile.toString(),
                    ),
                    const SizedBox(height: 30),
                    const Text('Enter your name as displayed on :'),
                    MediaTextField(
                      url: 'assets/images/facebook.png',
                      title: 'Facebook',
                      initValue: _facebook,
                      onlyRead: _onlyRead,
                      focus: _facebookFocus,
                      save: (val) => _facebook = val,
                      fieldSubmit: (_) =>
                          FocusScope.of(context).requestFocus(_instagramFocus),
                    ),
                    MediaTextField(
                      url: 'assets/images/instagram.png',
                      title: 'Instagram',
                      initValue: _instagram,
                      onlyRead: _onlyRead,
                      focus: _instagramFocus,
                      save: (val) => _instagram = val,
                      fieldSubmit: (_) =>
                          FocusScope.of(context).requestFocus(_twitterFocus),
                    ),
                    MediaTextField(
                      url: 'assets/images/twitter.png',
                      title: 'Twitter',
                      initValue: _twitter,
                      onlyRead: _onlyRead,
                      focus: _twitterFocus,
                      save: (val) => _twitter = val,
                      fieldSubmit: (_) =>
                          FocusScope.of(context).requestFocus(_youtubeFocus),
                    ),
                    MediaTextField(
                      url: 'assets/images/youtube.png',
                      title: 'Youtube',
                      initValue: _youtube,
                      onlyRead: _onlyRead,
                      focus: _youtubeFocus,
                      save: (val) => _youtube = val,
                      fieldSubmit: (_) =>
                          FocusScope.of(context).requestFocus(_googleFocus),
                    ),
                    MediaTextField(
                      url: 'assets/images/google.png',
                      title: 'Google',
                      initValue: _google,
                      onlyRead: _onlyRead,
                      focus: _googleFocus,
                      save: (val) => _google = val,
                      fieldSubmit: (_) => _saveProfile(),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      bottomS: Container(
        width: double.infinity,
        height: 50,
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: RawMaterialButton(
          constraints: const BoxConstraints(
            maxHeight: 50,
          ),
          onPressed: () {
            _onlyRead == false
                ? setState(() {
                    _saveProfile();
                  })
                : setState(() {
                    _onlyRead = false;
                  });
          },
          child: Center(
            child: _onlyRead == true
                ? const Text(
                    'Edit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : const Text(
                    'Save',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class MediaTextField extends StatelessWidget {
  final String url;
  final String title;
  final String initValue;
  final FocusNode focus;
  final Function fieldSubmit;
  final bool onlyRead;
  final Function save;

  MediaTextField({
    this.url,
    this.title,
    this.initValue,
    this.focus,
    this.fieldSubmit,
    this.onlyRead,
    this.save,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            height: 38,
            width: 30,
            child: Image.asset(url),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: title),
              initialValue: initValue,
              focusNode: focus,
              enableSuggestions: false,
              autocorrect: false,
              readOnly: onlyRead,
              onChanged: save,
              onFieldSubmitted: fieldSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final FocusNode focusName;
  final String initValue;
  final bool passwordField;
  final bool onlyRead;
  final Function save;
  final Function fieldSubmit;

  const ProfileTile({
    this.title,
    this.focusName,
    this.initValue,
    this.passwordField = false,
    this.onlyRead = true,
    this.save,
    this.fieldSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(labelText: title),
        initialValue: initValue,
        obscureText: passwordField,
        enableSuggestions: false,
        autocorrect: false,
        readOnly: onlyRead,
        onChanged: save,
        focusNode: focusName,
        onFieldSubmitted: fieldSubmit,
      ),
    );
  }
}
