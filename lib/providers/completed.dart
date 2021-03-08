import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class Completed {
  final int id;
  final int authorId;
  final int campaignId;
  final int userId;
  final String userName;
  final String screenshot;
  final DateTime submitDate;
  final String complain;
  final DateTime complainDate;
  final String status;
  final String approveBy;
  final DateTime approveDate;
  final int media;
  final int action;
  final int cost;
  final String pageUrl;

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
  final String _auth;
  final int _user;

  CompletedData(this._auth, this._user);

  bool status;
  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';

  List<Completed> _data = [];

  List<Completed> get data {
    return [..._data];
  }

  Future<bool> createCompleted(Completed newData) async {
    // print('completed.dart :: screenshot :::::::::::: ${newData.screenshot}');
    const _url = '$_halfUrl/completed/create.php';
    const _urlImage = '$_halfUrl/completed/create_image.php';

    var request = http.MultipartRequest("POST", Uri.parse(_urlImage));
    var pic =
        await http.MultipartFile.fromPath('imagefile', newData.screenshot);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print('completed.dart :: createCompleted :: responseString ::::::::::::::::::::::: $responseString');

    final result = await http
        .post(
      _url,
      headers: {'content-type': 'application/json', 'authorization': '$_auth'},
      body: json.encode({
        'campaign': newData.campaignId,
        'author': newData.authorId,
        'user': _user,
        'screenshot': responseString,
      }),
    ).catchError((error) {
      print('completed.dart :: createCompleted :: error ::::::::::::::::::::::: $error');
    });
    print('completed.dart :: createCompleted :: response ::::::::::::::::::::::: ${result.body}');
    ///
    if (result.statusCode == 401) {
      Auth().logout();
    }
    ///
    if (result.statusCode == 201) {
      print('201');
      return true;
    } else {
      print('false');
      return false;
    }
  }

  Future<void> next(Completed newData) async {
    print('completed.dart :: next :::::::::::::::::::::::: next called');
    const _url = '$_halfUrl/completed/next.php';
    final result = await http.post(
        _url,
        headers: {'content-type': 'application/json', 'authorization': '$_auth'},
        body: jsonEncode({
          'campaign': newData.campaignId,
          'author': newData.authorId,
          'user': _user,
        })
    ).catchError((error) {
      print('completed.dart :: next :: error :::::::::::::::::::::: $error');
      throw error;
    });
    print('completed.dart :: next :: response :::::::::::::::::::::: ${jsonDecode(result.body)}');
  }

  Future<void> read(int campId) async {
    final _url = '$_halfUrl/completed/read.php?camp=$campId&author=$_user';

    return await http
        .get(_url, headers: {'authorization': '$_auth'}).then((value) {
      final _extractedData = json.decode(value.body) as Map<String, dynamic>;

      ///
      if (value.statusCode == 401) {
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
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> approve(int compId) async {
    _data.removeWhere((ele) => ele.id == compId);
    notifyListeners();

    final _url = '$_halfUrl/completed/approve.php?id=$compId';
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

  Future<bool> cancel(int compId, String complain) async {
    final _url = '$_halfUrl/completed/complain.php';

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
