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
    print('completed.dart :: screenshot :::::::::::: ${newData.screenshot}');
    const _url = '$_halfUrl/completed/create.php';
    const _urlImage = '$_halfUrl/completed/create_image.php';
    bool status;

    var request = http.MultipartRequest("POST", Uri.parse(_urlImage));
    var pic =
        await http.MultipartFile.fromPath('imagefile', newData.screenshot);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);

    await http
        .post(
      _url,
      headers: {'content-type': 'application/json', 'authorization': '$_auth'},
      body: json.encode({
        'campaign': newData.campaignId,
        'author': newData.authorId,
        'user': newData.userId,
        'screenshot': responseString,
      }),
    )
        .then((value) async {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 201) {
        print('201');
        status = true;
        return true;
      } else {
        status = false;
        print('false');
        return false;
      }
    }).catchError((error) {
      return false;
    });
    return status;
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
    final _url = '$_halfUrl/completed/approve.php?id=$compId';

    return await http
        .patch(_url, headers: {'authorization': '$_auth'}).then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      throw error;
    });
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

  Future<bool> myHistory() async {
    final _url = '$_halfUrl/completed/history.php?id=$_user';

    return await http
        .get(_url, headers: {'authorization': '$_auth'}).then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        final _extractedData = json.decode(value.body) as Map<String, dynamic>;
        print('completed :: extractedData :::::::: $_extractedData');
        if (_extractedData['data'] == null) {
          _data.clear();
        } else {
          List<Completed> _fetchedData = [];
          _extractedData['data']['campaign'].forEach((value) {
            _fetchedData.add(Completed(
              id: int.parse(value['id']),
              screenshot: value['screenshot'],
              submitDate: DateTime.parse(value['submitDate']),
              media: int.parse(value['media']),
              action: int.parse(value['action']),
              userName: value['authorName'],
              authorId: int.parse(value['author']),
              campaignId: int.parse(value['campId']),
              userId: _user,
              cost: int.parse(value['cost']),
              pageUrl: value['pageUrl'],
            ));
          });
          _data = _fetchedData;
          notifyListeners();
        }
      } else {
        _data.clear();
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> myHistoryDetails(int id) async {
    final _url = '$_halfUrl/completed/history_single.php?id=$id';

    return await http
        .get(_url, headers: {'authorization': '$_auth'}).then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        final _extractedData = jsonDecode(value.body);

        if (_extractedData['data']['campaign'] == null) {
          _data.clear();
          return false;
        } else {
          List<Completed> _fetchedData = [];
          _extractedData['data']['campaign'].forEach((value) {
            _fetchedData.add(
              Completed(
                id: _extractedData['data']['campaign']['id'],
                screenshot: _extractedData['data']['campaign']['screenshot'],
                submitDate: _extractedData['data']['campaign']['submitDate'],
              ),
            );
            _data = _fetchedData;
            notifyListeners();
            return true;
          });
        }
      } else {
        _data.clear();
        return false;
      }
    }).catchError((error) {
      _data.clear();
      print(error);
      return false;
    });
  }

  /// API COMPLETED TILL HERE ///

}
