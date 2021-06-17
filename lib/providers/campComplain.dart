import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class CampComplain {
  final String? id;
  final int? campaign;
  final int? author;
  final int? user;
  final String? complain;

  CampComplain({
    this.id,
    this.campaign,
    this.author,
    this.user,
    this.complain,
  });
}

class CampComplainData with ChangeNotifier {
  final String? _auth;
  final int? _userId;
  CampComplainData(this._auth, this._userId);

  final String _website = 'www.likeandshare.app';
  final String _address = '/admin/v2/campComplain';

  Future<bool> createComplain(CampComplain newData) async {
    final _url = Uri.https(_website, '$_address/create.php');

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
        'user': _userId,
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
