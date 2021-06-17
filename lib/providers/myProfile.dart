import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class MyProfile with ChangeNotifier {
  final int id;
  final String? name;
  final String? city;
  final String? email;
  final int? mobile;
  final String? password;
  final int? hearts;
  final int? holdOut;
  final int? holdIn;
  final String? status;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? youtube;
  final String? google;
  final int? refBy;
  final int? chosen;
  final int? score;

  MyProfile({
    required this.id,
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
    this.score,
  });
}

class MyProfileData with ChangeNotifier {
  final String? _auth;
  final int? _userId;
  MyProfileData(this._auth, this._userId, this._data);

  final String _website = 'www.likeandshare.app';
  final String _address = '/admin/v2/user';

  bool? success;
  String? msg;
  int? chosenId;

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
    score: 0,
  );

  MyProfile get data {
    return _data;
  }

  Future<int> register(MyProfile newData) async {
    final _url = Uri.https(_website, '$_address/create.php');

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

    final result =  await http
        .post(
      _url,
      headers: _header,
      body: jsonEncode(_body),
    ).catchError((error) {
      throw error;
    });
print('myProfile.dart :: register :: status :::::::::::::::::::::::::::::: ${result.statusCode}');
    final _extractedData = jsonDecode(result.body) as Map<String, dynamic>?;
    if (result.statusCode == 201) {
      final _registerData = _extractedData!['data'] as Map<String, dynamic>;
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
    } else if (result.statusCode == 400) {
      msg = _extractedData!['messages'][0];
      return 400;
    } else {
      return 500;
    }
  }

  Future<int> googleRegister(MyProfile newData) async {
    final _url = Uri.https(_website, '$_address/create_google.php');

    Map<String, String> _header = {
      'content-type': 'application/json',
    };
    Map _body = {
      'name': newData.name,
      'email': newData.email,
      'password': newData.password,
      'mobile': 0,
    };

    final result =  await http
        .post(
      _url,
      headers: _header,
      body: jsonEncode(_body),
    ).catchError((error) {
      throw error;
    });

    final _extractedData = jsonDecode(result.body) as Map<String, dynamic>?;
    if (result.statusCode == 201) {
      final _registerData = _extractedData!['data'] as Map<String, dynamic>;
      final _userData = _registerData['campaign'] as Map<String, dynamic>;
      _data = MyProfile(
        id: int.parse(_userData['id']),
        name: _userData['name'],
        mobile: 0,
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
    } else if (result.statusCode == 400) {
      msg = _extractedData!['messages'][0];
      return 400;
    } else {
      return 500;
    }
  }

  Future<int> refreshData() async {
    final _url = Uri.https(_website, '$_address/read_single.php', {'id': '$_userId'});

    final result = await http
        .get(_url, headers: {'authorization': '$_auth'});

      if (result.statusCode == 200) {
        final _extractedData = jsonDecode(result.body) as Map<String, dynamic>;
        MyProfile _newData;
        _newData = MyProfile(
          id: int.parse(_extractedData['data']['campaign']['id']),
          name: _extractedData['data']['campaign']['name'],
          city: _extractedData['data']['campaign']['city'],
          mobile: int.parse(_extractedData['data']['campaign']['mobile']),
          email: _extractedData['data']['campaign']['email'],
          hearts: int.parse(_extractedData['data']['campaign']['hearts']),
          holdOut: int.parse(_extractedData['data']['campaign']['holdOut']),
          holdIn: int.parse(_extractedData['data']['campaign']['holdIn']),
          status: _extractedData['data']['campaign']['status'],
          chosen: int.parse(_extractedData['data']['campaign']['chosen']),
          score: int.parse(_extractedData['data']['campaign']['score']),
        );
        _data = _newData;
        notifyListeners();
      }
      return result.statusCode;
  }

  Future<bool> updateMyProfile(MyProfile newData) async {
    final _url = Uri.https(_website, '$_address/update.php', {'id': _data.id});

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
      final _extractedData = json.decode(value.body) as Map<String, dynamic>?;

      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        _data = MyProfile(
          id: int.parse(_extractedData!['data']['campaign']['id']),
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

  Future<bool> changePassword(String? oldPassword, String? newPassword) async {
    final _url = Uri.https(_website, '$_address/change_password.php', {'id': '$_userId'});

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
  /// api check done till here 25-01-2021 ///
}
