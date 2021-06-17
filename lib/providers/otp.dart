import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class OtpData extends ChangeNotifier {
  int? id;
  int? _userId;

  final String _website = 'www.likeandshare.app';
  final String _address = '/admin/v2/user';

  Future<bool> forgotPassword(String? email) async {
    final _url = Uri.https(_website, '$_address/forgot_password.php');

    Map<String, String> _header = {'content-type': 'application/json'};
    final Map _body = {'email': email};

    return await http
        .post(_url, headers: _header, body: jsonEncode(_body))
        .then((value) {
      final _extractedData = jsonDecode(value.body);

      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        id = int.parse(_extractedData['data']['id']);
        _userId = int.parse(_extractedData['data']['userId']);
        return true;
      }
      return false;
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> resendOtp() async {
    final _url = Uri.https(_website, '$_address/resend_otp.php', {'userId': '$_userId'});

    final result =  await http.post(_url).catchError((error) {
      throw error;
    });

      if (result.statusCode == 200) {
        return true;
      } else if (result.statusCode == 401) {
        Auth().logout();
        return false;
      } else {
        return false;
      }
  }

  Future<bool> enterOtp(int? pass) async {
    final _url = Uri.https(_website, '$_address/enter_otp.php');

    Map<String, String> _header = {'content-type': 'application/json'};
    final Map _body = {'otpId': id, 'pass': pass};

    return await http
        .post(_url, headers: _header, body: jsonEncode(_body))
        .then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      final _extractedData = jsonDecode(value.body);
      print(_extractedData);
      if (value.statusCode == 200) {
        _userId = int.parse(_extractedData['data']['userId']);
        return true;
      }
      return false;
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> resetPassword(String? password) async {
    final _url = Uri.https(_website, '$_address/reset_password.php');

    Map<String, String> _header = {'content-type': 'application/json'};
    final Map _body = {
      'id': _userId,
      'password': password,
    };

    return await http
        .patch(_url, headers: _header, body: jsonEncode(_body))
        .then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        return true;
      }
      return false;
    }).catchError((error) {
      throw error;
    });
  }
}
