import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class CampComplain {
  final String id;
  final int campaign;
  final int author;
  final int user;
  final String complain;

  CampComplain({this.id, this.campaign, this.author, this.user, this.complain});
}

class CampComplainData with ChangeNotifier {
  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';

  final String _auth;
  final int _user;
  CampComplainData(this._auth, this._user);

  Future<bool> createComplain(CampComplain newData) async {
    const _url = '$_halfUrl/campComplain/create.php';
    final result = await http
        .post(
      _url,
      headers: {
        'content-type': 'application/json',
        'authorization': '$_auth',
      },
      body: json.encode({
        'campaign': newData.campaign,
        'author': newData.author,
        'user': _user,
        'complain': newData.complain,
      }),
    ).catchError((error) {
      throw error;
    });

    if (result.statusCode == 201) {
      return true;
    } else if (result.statusCode == 401) {
      Auth().logout();
      return false;
    }
    else {
      return false;
    }
  }
}
