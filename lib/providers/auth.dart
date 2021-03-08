import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';
  String _auth;
  int _userId;
  // DateTime _expiryDate;
  // Timer _authTimer;

  bool get isAuth {
    /// isAuth is of type bool. below if it is true it
    /// will return true else it wil return false
    return _auth != null;
  }

  String get token {
    if (
        // _expiryDate != null &&
        //     _expiryDate.isAfter(DateTime.now()) &&
        _auth != null) {
      return _auth;
    }
    return null;
  }

  int get user {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  Future<bool> authenticate(String email, String password) async {
    final _url = '$_halfUrl/user/login.php';
    Map _body = {
      'email': email,
      'password': password,
    };

    return await http
        .post(
      _url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(_body),
    )
        .then((value) async {
      if (value.statusCode == 200) {
        final _extractedData = jsonDecode(value.body);
        _auth = _extractedData['data']['user']['auth'];
        _userId = int.parse(_extractedData['data']['user']['id']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userData = jsonEncode({'token': _auth, 'userId': _userId});
        prefs.setString('userData', userData);

        notifyListeners();
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final _extractedUserData = jsonDecode(prefs.getString('userData'));
      _auth = _extractedUserData['token'];
      _userId = _extractedUserData['userId'];
      notifyListeners();
      return true;
    }
  }

  Future<void> logout() async {
    _auth = null;
    // _expiryDate = null;
    _userId = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    notifyListeners();

    // if (_authTimer != null) {
    //   _authTimer.cancel();
    //   _authTimer = null;
    // }
  }
}
