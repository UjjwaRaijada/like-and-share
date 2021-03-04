import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class OtpData extends ChangeNotifier {
  int id;
  int userId;

  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';

  Future<bool> forgotPassword(String email) async {
    final _url = '$_halfUrl/user/forgot_password.php';
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
        userId = int.parse(_extractedData['data']['userId']);
        return true;
      }
      return false;
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> resendOtp() async {
    final _url = '$_halfUrl/user/resend_otp.php?userId=$userId';

    return await http.post(_url).then((value) {
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

  Future<bool> enterOtp(int pass) async {
    final _url = '$_halfUrl/user/enter_otp.php';
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
        userId = int.parse(_extractedData['data']['userId']);
        return true;
      }
      return false;
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> resetPassword(String password) async {
    final _url = '$_halfUrl/user/reset_password.php';
    Map<String, String> _header = {'content-type': 'application/json'};
    final Map _body = {
      'id': userId,
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
