import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class CampaignClass {
  final int id;
  final String? name;
  final int author;
  final String authorName;
  final int? actionId;
  final String? actionName;
  final String? actionIcon;
  final String pageUrl;
  final int qty;
  final int cost;
  // final String dateString;
  final DateTime createdOn;
  int? heartPending;
  int? heartGiven;
  final int? heartReturned;
  final int? premium;
  final int? count;

  CampaignClass({
    required this.id,
    this.name,
    required this.author,
    required this.authorName,
    this.actionId,
    this.actionName,
    this.actionIcon,
    required this.pageUrl,
    required this.qty,
    required this.cost,
    // required this.dateString,
    required this.createdOn,
    this.heartPending,
    this.heartGiven,
    this.heartReturned,
    this.premium,
    this.count,
  });
}

class CampaignData with ChangeNotifier {
  final String? _auth;
  final _userId;
  CampaignData(this._auth, this._userId, this._data);

  final String _website = 'www.likeandshare.app';
  final String _address = '/admin/v2/campaign';

  int? chosenId;
  List<CampaignClass> _data = [];

  List<CampaignClass> get data {
    return [..._data];
  }

  List<CampaignClass> _premiumData = [];

  List<CampaignClass> get premiumData {
    return [..._premiumData];
  }

  CampaignClass? _singleData;

  CampaignClass? get singleData {
    return _singleData;
  }


  Future<bool> premiumCamp() async {
    final _url = Uri.https(_website, '$_address/read_premium.php', {'author': '$_userId'});
    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      _premiumData.clear();
      throw error;
    });
    if (result.statusCode == 200) {
      final _extData = jsonDecode(result.body) as Map<String, dynamic>;
      if (_extData['data'] == null) {
        _premiumData.clear();
        return true;
      } else {
        List<CampaignClass> _newData = [];
        _extData['data']['campaign'].forEach((val) {
          _newData.add(CampaignClass(
            id: int.parse(val['cid']),
            author: int.parse(val['author']),
            authorName: val['authorName'],
            actionName: val['actionName'],
            actionIcon: val['actionIcon'],
            pageUrl: val['pageUrl'],
            qty: int.parse(val['qty']),
            cost: int.parse(val['cost']),
            createdOn: val['createdOn'],
            heartPending: int.parse(val['heartPending']),
            heartReturned: int.parse(val['heartReturned']),
            heartGiven: int.parse(val['heartGiven']),
            count: int.parse(val['count']),
          ));
        });
        _premiumData = _newData;
        notifyListeners();
        return true;
      }
    } else if (result.statusCode == 401) {
      Auth().logout();
      return false;
    } else {
      _premiumData.clear();
      return false;
    }
  }

  Future<bool> addCampaign(CampaignClass newData) async {
    final _url = Uri.https(_website, '$_address/create.php');
    final Map<String, String> _header = {
      'content-type': 'application/json',
      'authorization': '$_auth',
    };

    final result = await http
        .post(
      _url,
      headers: _header,
      body: json.encode({
        "author": _userId,
        "name" : newData.name,
        "actionId": newData.actionId,
        "pageUrl": newData.pageUrl,
        "qty": newData.qty,
        "cost": newData.cost,
      }),
    ).catchError((error) {
      throw error;
    });
    if (result.statusCode == 401) {
      Auth().logout();
    }
    if (result.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // Future<void> fetchCampaign() async {
  //   final _url = Uri.https(_website, '$_address/read.php', {'author': '$_userId'});
  //
  //   final result = await http
  //       .get(_url, headers: {'authorization': '$_auth'});
  //
  //     if (result.statusCode == 200) {
  //       final _extData = json.decode(result.body) as Map<String, dynamic>;
  //
  //       if (_extData['data'] == null) {
  //         _data.clear();
  //       } else {
  //         List<CampaignClass> _newData = [];
  //         _extData['data']['campaign'].forEach((val) {
  //           _newData.add(CampaignClass(
  //             id: int.parse(val['cid']),
  //             author: int.parse(val['author']),
  //             authorName: val['authorName'],
  //             actionName: val['actionName'],
  //             actionIcon: val['actionIcon'],
  //             pageUrl: val['pageUrl'],
  //             qty: int.parse(val['qty']),
  //             cost: int.parse(val['cost']),
  //             createdOn: DateFormat("dd/MM/yyyy").parse(val['createdOn']),
  //             heartPending: 0,
  //             heartReturned: 0,
  //             heartGiven: 0,
  //           ));
  //         });
  //         _data = _newData;
  //         notifyListeners();
  //       }
  //     } else {
  //       _data.clear();
  //     }
  // }

  Future<int> createCompleted(CampaignClass newData, String urlImage) async {
    if(_data.isNotEmpty && newData.premium == 0){
      _data.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    if(_premiumData.isNotEmpty && newData.premium == 1){
      _premiumData.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    final _url = Uri.https(_website, '/admin/v2/completed/create.php');
    final _urlImage = Uri.https(_website, '/admin/v2/completed/create_image.php');

    var request = http.MultipartRequest("POST", _urlImage);
    var pic =
    await http.MultipartFile.fromPath('imagefile', urlImage);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    final result = await http
        .post(
      _url,
      headers: {'content-type': 'application/json', 'authorization': '$_auth'},
      body: json.encode({
        'campaign': newData.id,
        'author': newData.author,
        'user': _userId,
        'screenshot': responseString,
      }),
    ).catchError((error) {
    });
    ///
    if (result.statusCode == 401) {
      Auth().logout();
    }
    ///
    // if (result.statusCode == 201) {
    //     final _extData = json.decode(result.body) as Map<String, dynamic>;
    //     if (_extData['data'] == null) {
    //       _data.clear();
    //     } else {
    //       _singleData = CampaignClass(
    //         id: int.parse(_extData['data']['campaign']['id']),
    //         author: int.parse(_extData['data']['campaign']['author']),
    //         authorName: _extData['data']['campaign']['authorName'],
    //         media: stringToMedia,
    //         action: stringToAction,
    //         urlImage: _extData['data']['campaign']['urlImage'],
    //         pageUrl: _extData['data']['campaign']['pageUrl'],
    //         qty: int.parse(_extData['data']['campaign']['qty']),
    //         cost: int.parse(_extData['data']['campaign']['cost']),
    //         dateString: _extData['data']['campaign']['createdOn'],
    //         heartPending: int.parse(_extData['data']['campaign']['heartPending']),
    //         heartReturned: int.parse(_extData['data']['campaign']['heartReturned']),
    //         heartGiven: int.parse(_extData['data']['campaign']['heartGiven']),
    //         premium: int.parse(_extData['data']['campaign']['premium']),
    //       );
    //       notifyListeners();
    //     }
    //     return true;
    //   } else {
      return result.statusCode;
  }

  Future<void> fetchAvailableCampaign() async {
    final _url = Uri.https(_website, '$_address/read_available.php',
        {'author': '$_userId'});

    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      _data.clear();
      throw error;
    });
print(jsonDecode(result.body));
    if (result.statusCode == 200) {
      final _extData = json.decode(result.body) as Map<String, dynamic>;
      if (_extData['data'] == null) {
        _data.clear();
      } else {
        _extData['data']['campaign'].forEach((val) {
          _data.add(CampaignClass(
            id: int.parse(val['cid']),
            author: int.parse(val['author']),
            authorName: val['authorName'],
            actionName: val['actionName'],
            pageUrl: val['pageUrl'],
            qty: int.parse(val['qty']),
            cost: int.parse(val['cost']),
            createdOn: DateTime.parse(val['createdOn']),
            heartPending: int.parse(val['heartPending']),
            heartReturned: int.parse(val['heartReturned']),
            heartGiven: int.parse(val['heartGiven']),
          ));
        });
        notifyListeners();
      }
    } else if (result.statusCode == 401) {
      Auth().logout();
    } else {
      _data.clear();
    }

  }

  // Future<bool> fetchSingleCampaign(int id) async {
  //   final _url = Uri.https(_website, '$_address/read_single.php', {'id': '$id'});
  //
  //   final result = await http.get(_url).catchError((error) {
  //     throw error;
  //   });
  //
  //   ///
  //   if (result.statusCode == 401) {
  //     Auth().logout();
  //   }
  //
  //   ///
  //   if (result.statusCode == 200) {
  //     final _extData = json.decode(result.body) as Map<String, dynamic>;
  //     _singleData = CampaignClass(
  //       id: int.parse(_extData['data']['campaign']['id']),
  //       author: int.parse(_extData['data']['campaign']['author']),
  //       authorName: _extData['data']['campaign']['authorName'],
  //       actionName: _extData['data']['campaign']['actionName'],
  //       pageUrl: _extData['data']['campaign']['pageUrl'],
  //       qty: int.parse(_extData['data']['campaign']['qty']),
  //       cost: int.parse(_extData['data']['campaign']['cost']),
  //       heartPending:
  //           int.parse(_extData['data']['campaign']['heartPending']),
  //       heartReturned:
  //           int.parse(_extData['data']['campaign']['heartReturned']),
  //       heartGiven: int.parse(_extData['data']['campaign']['heartGiven']),
  //       premium: int.parse(_extData['data']['campaign']['premium']),
  //       createdOn: DateTime.now(),
  //     );
  //     notifyListeners();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> myCampaign() async {
    final _url = Uri.https(_website, '$_address/my_camp.php', {'user': '$_userId'});

    final result = await http
        .get(_url, headers: {'authorization': '$_auth'});

    if(result.statusCode == 200) {
      final _extData = json.decode(result.body) as Map<String, dynamic>;

      List<CampaignClass> _newData = [];
      _extData['data']['campaign'].forEach((val) {
        _newData.add(CampaignClass(
          id: int.parse(val['id']),
          name: val['name'],
          author: int.parse(val['author']),
          authorName: '',
          actionName: val['actionName'],
          pageUrl: val['pageUrl'],
          qty: int.parse(val['qty']),
          cost: int.parse(val['cost']),
          createdOn: DateTime.parse(val['createdOn']),
          heartPending: int.parse(val['heartPending']),
          heartReturned: int.parse(val['heartReturned']),
          heartGiven: int.parse(val['heartGiven']),
          count: int.parse(val['count']),
        ));
      });
      _data = _newData;
    }
      notifyListeners();
  }

  Future<void> cancel(CampaignClass newData) async {
    if(_data.isNotEmpty && newData.premium == 0){
      _data.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    if(_premiumData.isNotEmpty && newData.premium == 1){
      _premiumData.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    final _url = Uri.https(_website, '$_address/next.php');

    await http.post(
        _url,
        headers: {'content-type': 'application/json', 'authorization': '$_auth'},
        body: jsonEncode({
          'campaign': newData.id,
          'author': newData.author,
          'user': _userId,
        })
    ).catchError((error) {
      throw error;
    });
  }

  void approve(int id) {

    int _pending = _data.firstWhere((ele) => ele.id == id).heartPending!;
    int _given = _data.firstWhere((ele) => ele.id == id).heartGiven!;
print(_data.firstWhere((ele) => ele.id == id).heartPending);
    _data.firstWhere((ele) => ele.id == id).heartPending = _pending - _data.firstWhere((ele) => ele.id == id).cost;
    _data.firstWhere((ele) => ele.id == id).heartGiven = _given + _data.firstWhere((ele) => ele.id == id).cost;
    notifyListeners();
  }

  void removeData(int id) async {
    print('called :::::::::::: $id');
      _data.removeWhere((ele) => ele.id == id);
      notifyListeners();
  }
  void removeDataPremium(int? id) {
    if(_data.isNotEmpty){
      _premiumData.removeWhere((ele) => ele.id == id);
      notifyListeners();
    }
  }

  void clearData() {
    if(_data.isNotEmpty) {
      _data.clear();
    }
  }
/// API DONE TILL HERE ///
}
