import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class Completed {
  final int? id;
  final int? authorId;
  final int? campaignId;
  final int? userId;
  final String? userName;
  final String? screenshot;
  final DateTime? submitDate;
  final String? complain;
  final DateTime? complainDate;
  final String? status;
  final String? approveBy;
  final DateTime? approveDate;
  final int? media;
  final int? action;
  final int? cost;
  final String? pageUrl;

  Completed({
    this.id,
    this.authorId,
    this.campaignId,
    this.userId,
    this.userName,
    this.screenshot,
    this.submitDate,
    this.complain,
    this.complainDate,
    this.status,
    this.approveBy,
    this.approveDate,
    this.media,
    this.action,
    this.cost,
    this.pageUrl,
  });
}

class CompletedData with ChangeNotifier {
  final String? _auth;
  final int? _userId;

  CompletedData(this._auth, this._userId);

  bool? status;

  List<Completed> _data = [];

  List<Completed> get data {
    return [..._data];
  }

  Future<void> next(Completed newData) async {
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/completed/next.php');

    final result = await http.post(
        _url,
        headers: {'content-type': 'application/json', 'authorization': '$_auth'},
        body: jsonEncode({
          'campaign': newData.campaignId,
          'author': newData.authorId,
          'user': _userId,
        })
    ).catchError((error) {
      print('completed.dart :: next :: error :::::::::::::::::::::: $error');
      throw error;
    });
    print('completed.dart :: next :: response :::::::::::::::::::::: ${jsonDecode(result.body)}');
  }

  Future<void> read(int? campId) async {
    print('ok ok');
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/completed/read.php',
        {'camp': '$campId', 'author': '$_userId'});

    final result = await http
      .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
        throw error;
      });
print(json.decode(result.body));

      final _extractedData = json.decode(result.body) as Map<String, dynamic>;

      ///
      if (result.statusCode == 401) {
        Auth().logout();
      }
      ///
      if (_extractedData['success'] == false) {
        _data = [];
      } else if (_extractedData['data'] == null) {
        _data = [];
      } else {
        List<Completed> _fetchedData = [];

        _extractedData['data']['completed'].forEach((value) {
          _fetchedData.add(Completed(
            id: int.parse(value['id']),
            userName: value['userName'],
            screenshot: value['screenshot'],
            submitDate: DateTime.parse(value['submitDate']),
          ));
        });
        _data = _fetchedData;
      }
      notifyListeners();
  }

  Future<bool> approve(int? compId) async {
    _data.removeWhere((ele) => ele.id == compId);
    notifyListeners();

    final _url = Uri.https('www.likeandshare.app', '/admin/v1/completed/approve.php', {'id': '$compId'});

    final result = await http
        .patch(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      throw error;
    });
    ///
    if (result.statusCode == 401) {
      Auth().logout();
    }
    ///
    if (result.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> cancel(int? compId, String? complain) async {
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/completed/complain.php');

    return await http
        .patch(_url,
            headers: {
              'content-type': 'application/json',
              'authorization': '$_auth'
            },
            body: jsonEncode({'id': compId, 'complain': complain}))
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

  /// API COMPLETED TILL HERE ///

}
