import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class MyProfile with ChangeNotifier {
  final int id;
  final String name;
  final String city;
  final String email;
  final int mobile;
  final String password;
  final int hearts;
  final int holdOut;
  final int holdIn;
  final String status;
  final String facebook;
  final String instagram;
  final String twitter;
  final String youtube;
  final String google;
  final int refBy;
  final int chosen;

  MyProfile({
    this.id,
    this.name,
    this.city,
    this.email,
    this.mobile,
    this.password,
    this.hearts,
    this.status,
    this.holdOut,
    this.holdIn,
    this.facebook,
    this.instagram,
    this.twitter,
    this.youtube,
    this.google,
    this.refBy,
    this.chosen,
  });
}

class MyProfileData with ChangeNotifier {
  final String _auth;
  final int _userId;
  MyProfileData(this._auth, this._userId);

  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';
  bool success;
  String msg;
  int chosenId;

  MyProfile _data = MyProfile(
    id: 0,
    name: '',
    city: '',
    email: '',
    hearts: 0,
    holdIn: 0,
    holdOut: 0,
    status: '',
    mobile: 0,
    facebook: '',
    instagram: '',
    twitter: '',
    youtube: '',
    google: '',
    refBy: 0,
    chosen: 0,
  );

  MyProfile get data {
    return _data;
  }

  Future<int> register(MyProfile newData) async {
    const _url = '$_halfUrl/user/create.php';
    Map<String, String> _header = {
      'content-type': 'application/json',
    };
    Map _body = {
      'name': newData.name,
      'email': newData.email,
      'mobile': newData.mobile,
      'password': newData.password,
      'refBy': newData.refBy,
    };

    return await http
        .post(
      _url,
      headers: _header,
      body: jsonEncode(_body),
    )
        .then((val) {
      final _extractedData = jsonDecode(val.body) as Map<String, dynamic>;
      if (val.statusCode == 201) {
        final _registerData = _extractedData['data'] as Map<String, dynamic>;
        final _userData = _registerData['campaign'] as Map<String, dynamic>;

        _data = MyProfile(
          id: int.parse(_userData['id']),
          name: _userData['name'],
          mobile: int.parse(_userData['mobile']),
          hearts: int.parse(_userData['hearts']),
          status: _userData['status'],
          email: _userData['email'],
          city: '',
          facebook: '',
          instagram: '',
          twitter: '',
          youtube: '',
          google: '',
          holdIn: 0,
          holdOut: 0,
        );
        notifyListeners();
        msg = _extractedData['messages'][0];
        return 201;
      } else if (val.statusCode == 400) {
        msg = _extractedData['messages'][0];

        return 400;
      } else {
        return 500;
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> refreshData() async {
    bool status;
    final String _url = '$_halfUrl/user/read_single.php?id=$_userId';
    await http
        .get(_url, headers: {'authorization': '$_auth'}).then((value) async {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        final _extractedData = jsonDecode(value.body) as Map<String, dynamic>;
        _data = MyProfile(
          id: int.parse(_extractedData['data']['campaign']['id']),
          name: _extractedData['data']['campaign']['name'],
          city: _extractedData['data']['campaign']['city'],
          mobile: int.parse(_extractedData['data']['campaign']['mobile']),
          email: _extractedData['data']['campaign']['email'],
          hearts: int.parse(_extractedData['data']['campaign']['hearts']),
          holdOut: int.parse(_extractedData['data']['campaign']['holdOut']),
          holdIn: int.parse(_extractedData['data']['campaign']['holdIn']),
          status: _extractedData['data']['campaign']['status'],
          facebook: _extractedData['data']['campaign']['facebook'],
          instagram: _extractedData['data']['campaign']['instagram'],
          twitter: _extractedData['data']['campaign']['twitter'],
          youtube: _extractedData['data']['campaign']['youtube'],
          google: _extractedData['data']['campaign']['google'],
          chosen: int.parse(_extractedData['data']['campaign']['chosen']),
        );
        notifyListeners();
        status = true;
        // return true;
      } else {
        status = false;
        // return false;
      }
    }).catchError((error) {
      print('myProfile.dart :: error ::::::::::: $error');

      status = false;
      // throw error;
    });
    return status;
  }

  Future<bool> updateMyProfile(MyProfile newData) async {
    final String _url = '$_halfUrl/user/update.php?id=${_data.id}';
    return await http
        .patch(
      _url,
      headers: {
        'Content-type': 'application/json',
        'authorization': '$_auth',
      },
      body: json.encode({
        'id': _data.id,
        'name': newData.name,
        'city': newData.city,
        'facebook': newData.facebook,
        'instagram': newData.instagram,
        'twitter': newData.twitter,
        'youtube': newData.youtube,
        'google': newData.google,
      }),
    )
        .then((value) {
      final _extractedData = json.decode(value.body) as Map<String, dynamic>;

      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        _data = MyProfile(
          id: int.parse(_extractedData['data']['campaign']['id']),
          name: _extractedData['data']['campaign']['name'],
          city: _extractedData['data']['campaign']['city'],
          mobile: int.parse(_extractedData['data']['campaign']['mobile']),
          email: _extractedData['data']['campaign']['email'],
          hearts: int.parse(_extractedData['data']['campaign']['hearts']),
          holdOut: int.parse(_extractedData['data']['campaign']['holdOut']),
          holdIn: int.parse(_extractedData['data']['campaign']['holdIn']),
          status: _extractedData['data']['campaign']['status'],
          facebook: _extractedData['data']['campaign']['facebook'],
          instagram: _extractedData['data']['campaign']['instagram'],
          twitter: _extractedData['data']['campaign']['twitter'],
          youtube: _extractedData['data']['campaign']['youtube'],
          google: _extractedData['data']['campaign']['google'],
          chosen: _extractedData['data']['campaign']['chosen'],
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final String _url = '$_halfUrl/user/change_password.php?id=$_userId';
    return await http
        .patch(
      _url,
      headers: {
        'Content-type': 'application/json',
        'authorization': '$_auth',
      },
      body: json.encode({
        'id': _userId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    )
        .then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> addChosen(int campId) async {
    final _url = '$_halfUrl/user/add_chosen.php';
    return await http
        .patch(_url,
            headers: {
              'Content-type': 'application/json',
              'authorization': '$_auth',
            },
            body: jsonEncode({'id': _userId, 'chosen': campId}))
        .then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        _data = MyProfile(
          id: _data.id,
          name: _data.name,
          city: _data.city,
          mobile: _data.mobile,
          email: _data.email,
          hearts: _data.hearts,
          holdOut: _data.holdOut,
          holdIn: _data.holdIn,
          status: _data.status,
          facebook: _data.facebook,
          instagram: _data.instagram,
          twitter: _data.twitter,
          youtube: _data.youtube,
          google: _data.google,
          chosen: campId,
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> removeChosen(int campId) async {
    final _url = '$_halfUrl/user/remove_chosen.php';
    return await http
        .patch(_url,
            headers: {
              'Content-type': 'application/json',
              'authorization': '$_auth',
            },
            body: jsonEncode({'id': _userId, 'chosen': campId}))
        .then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        _data = MyProfile(
          id: _data.id,
          name: _data.name,
          city: _data.city,
          mobile: _data.mobile,
          email: _data.email,
          hearts: _data.hearts,
          holdOut: _data.holdOut,
          holdIn: _data.holdIn,
          status: _data.status,
          facebook: _data.facebook,
          instagram: _data.instagram,
          twitter: _data.twitter,
          youtube: _data.youtube,
          google: _data.google,
          chosen: 0,
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      return false;
    });
  }

  /// api check done till here 25-01-2021 ///
}
