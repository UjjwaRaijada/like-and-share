import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './auth.dart';

enum Media {
  Facebook,
  Instagram,
  Twitter,
  YouTube,
  GoogleReview,
}

enum ActionType {
  Like,
  Share,
  Follow,
  Love,
  Retweet,
  Subscribe,
  Rate,
  Review,
}

Media? media;
String get mediaString {
  switch (media) {
    case Media.Facebook:
      return 'Facebook';
    case Media.Instagram:
      return 'Instagram';
    case Media.Twitter:
      return 'Twitter';
    case Media.YouTube:
      return 'YouTube';
    case Media.GoogleReview:
      return 'Google Review';
    default:
      return 'unknown';
  }
}

Media? mInt;
int get mediaInt {
  switch (mInt) {
    case Media.Facebook:
      return 1;
    case Media.Instagram:
      return 2;
    case Media.Twitter:
      return 3;
    case Media.YouTube:
      return 4;
    case Media.GoogleReview:
      return 5;
    default:
      return 0;
  }
}

int? mString;
Media get stringToMedia {
  switch (mString) {
    case 1:
      return Media.Facebook;
    case 2:
      return Media.Instagram;
    case 3:
      return Media.Twitter;
    case 4:
      return Media.YouTube;
    case 5:
      return Media.GoogleReview;
    default:
      return Media.GoogleReview;
  }
}

Media? mediaImage;
IconData get mediaToImage {
  switch (mediaImage) {
    case Media.Facebook:
      return FontAwesomeIcons.facebookF;
    case Media.Instagram:
      return FontAwesomeIcons.instagramSquare;
    case Media.Twitter:
      return FontAwesomeIcons.twitter;
    case Media.YouTube:
      return FontAwesomeIcons.youtube;
    case Media.GoogleReview:
      return FontAwesomeIcons.google;
    default:
      return FontAwesomeIcons.question;
  }
}

ActionType? action;
String get actionString {
  switch (action) {
    case ActionType.Like:
      return 'Like';
    case ActionType.Share:
      return 'Share';
    case ActionType.Follow:
      return 'Follow';
    case ActionType.Love:
      return 'Like';
    case ActionType.Retweet:
      return 'Retweet';
    case ActionType.Review:
      return 'Review';
    case ActionType.Subscribe:
      return 'Subscribe';
    case ActionType.Rate:
      return 'Rating';
    default:
      return 'unknown';
  }
}

ActionType? aInt;
int get actionInt {
  switch (aInt) {
    case ActionType.Like:
      return 1;
    case ActionType.Share:
      return 2;
    case ActionType.Follow:
      return 3;
    case ActionType.Retweet:
      return 4;
    case ActionType.Rate:
      return 5;
    case ActionType.Love:
      return 6;
    case ActionType.Subscribe:
      return 7;
    case ActionType.Review:
      return 8;
    default:
      return 0;
  }
}

int? aString;
ActionType get stringToAction {
  switch (aString) {
    case 1:
      return ActionType.Like;
    case 2:
      return ActionType.Share;
    case 3:
      return ActionType.Follow;
    case 4:
      return ActionType.Retweet;
    case 5:
      return ActionType.Rate;
    case 6:
      return ActionType.Love;
    case 7:
      return ActionType.Subscribe;
    case 8:
      return ActionType.Review;
    default:
      return ActionType.Like;
  }
}

ActionType? actionIcon;
IconData get actionToIcon {
  switch (actionIcon) {
    case ActionType.Like:
      return FontAwesomeIcons.thumbsUp;
    case ActionType.Share:
      return FontAwesomeIcons.shareAlt;
    case ActionType.Follow:
      return FontAwesomeIcons.users;
    case ActionType.Love:
      return FontAwesomeIcons.thumbsUp;
    case ActionType.Retweet:
      return FontAwesomeIcons.retweet;
    case ActionType.Review:
      return FontAwesomeIcons.penFancy;
    case ActionType.Subscribe:
      return FontAwesomeIcons.bell;
    case ActionType.Rate:
      return FontAwesomeIcons.solidStar;
    default:
      return FontAwesomeIcons.question;
  }
}

class CampaignClass {
  final int? id;
  final String? name;
  final int? author;
  final String? authorName;
  final Media? media;
  final ActionType? action;
  final String? urlImage;
  final String? pageUrl;
  final int? qty;
  final int? cost;
  final String? dateString;
  final DateTime? createdOn;
  int? heartPending;
  int? heartGiven;
  final int? heartReturned;
  final int? premium;
  final int? count;

  CampaignClass({
    this.id,
    this.name,
    this.author,
    this.authorName,
    this.media,
    this.action,
    this.urlImage,
    this.pageUrl,
    this.qty,
    this.cost,
    this.dateString,
    this.createdOn,
    this.heartPending,
    this.heartGiven,
    this.heartReturned,
    this.premium,
    this.count,
  });
}

class CampaignData with ChangeNotifier {
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

  final String? _auth;
  final _userId;
  CampaignData(this._auth, this._userId, this._data);

  Future<bool> premiumCamp() async {
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/read_premium.php', {'author': '$_userId'});
    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      _premiumData.clear();
      throw error;
    });
    if (result.statusCode == 200) {
      final _extractedData = jsonDecode(result.body) as Map<String, dynamic>;
      if (_extractedData['data'] == null) {
        _premiumData.clear();
        return true;
      } else {
        List<CampaignClass> _fetchedData = [];
        _extractedData['data']['campaign'].forEach((value) {
          mString = int.parse(value['media']);
          aString = int.parse(value['action']);
          _fetchedData.add(CampaignClass(
            id: int.parse(value['cid']),
            author: int.parse(value['author']),
            authorName: value['authorName'],
            media: stringToMedia,
            action: stringToAction,
            urlImage: value['urlImage'],
            pageUrl: value['pageUrl'],
            qty: int.parse(value['qty']),
            cost: int.parse(value['cost']),
            createdOn: DateFormat("dd/MM/yyyy").parse(value['createdOn']),
            heartPending: int.parse(value['heartPending']),
            heartReturned: int.parse(value['heartReturned']),
            heartGiven: int.parse(value['heartGiven']),
            count: int.parse(value['count']),
          ));
        });
        _premiumData = _fetchedData;
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
    mInt = newData.media;
    aInt = newData.action;

    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/create.php');
    final Map<String, String> _header = {
      'content-type': 'application/json',
      'authorization': '$_auth',
    };

    // var request = http.MultipartRequest("POST", Uri.parse(_urlImage));
    // var pic = await http.MultipartFile.fromPath('imagefile', newData.urlImage);
    // request.files.add(pic);
    // var response = await request.send();
    //
    // //Get the response from the server
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);

    final result = await http
        .post(
      _url,
      headers: _header,
      body: json.encode({
        "author": _userId,
        "name" : newData.name,
        "media": mediaInt,
        "action": actionInt,
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

  Future<void> fetchCampaign(Media media) async {
    mInt = media;
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/read.php', {'media': mediaInt, 'author': '$_userId'});

    return await http
        .get(_url, headers: {'authorization': '$_auth'}).then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      if (value.statusCode == 200) {
        final _extractedData = json.decode(value.body) as Map<String, dynamic>;
        if (_extractedData['data'] == null) {
          _data.clear();
        } else {
          List<CampaignClass> _fetchedData = [];
          _extractedData['data']['campaign'].forEach((value) {
            mString = int.parse(value['media']);
            aString = int.parse(value['action']);
            _fetchedData.add(CampaignClass(
              id: int.parse(value['cid']),
              author: int.parse(value['author']),
              authorName: value['authorName'],
              media: stringToMedia,
              action: stringToAction,
              urlImage: value['urlImage'],
              pageUrl: value['pageUrl'],
              qty: int.parse(value['qty']),
              cost: int.parse(value['cost']),
              createdOn: DateFormat("dd/MM/yyyy").parse(value['createdOn']),
              heartPending: 0,
              heartReturned: 0,
              heartGiven: 0,
            ));
          });
          _data = _fetchedData;
          notifyListeners();
        }
      } else {
        _data.clear();
      }
    }).catchError((error) {
      _data.clear();
      throw error;
    });
  }

  Future<bool> createCompleted(CampaignClass newData) async {
    if(_data.isNotEmpty && newData.premium == 0){
      _data.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    if(_premiumData.isNotEmpty && newData.premium == 1){
      _premiumData.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/completed/create.php');
    final _urlImage = Uri.https('www.likeandshare.app', '/admin/v1/completed/create_image.php');

    var request = http.MultipartRequest("POST", _urlImage);
    var pic =
    await http.MultipartFile.fromPath('imagefile', newData.urlImage!);
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
    if (result.statusCode == 201) {
      final _extractedData = json.decode(result.body) as Map<String, dynamic>;
      if (_extractedData['data'] == null) {
        _data.clear();
      } else {
        mString = int.parse(_extractedData['data']['campaign']['media']);
        aString = int.parse(_extractedData['data']['campaign']['action']);
        _singleData = CampaignClass(
          id: int.parse(_extractedData['data']['campaign']['id']),
          author: int.parse(_extractedData['data']['campaign']['author']),
          authorName: _extractedData['data']['campaign']['authorName'],
          media: stringToMedia,
          action: stringToAction,
          urlImage: _extractedData['data']['campaign']['urlImage'],
          pageUrl: _extractedData['data']['campaign']['pageUrl'],
          qty: int.parse(_extractedData['data']['campaign']['qty']),
          cost: int.parse(_extractedData['data']['campaign']['cost']),
          dateString: _extractedData['data']['campaign']['createdOn'],
          heartPending: int.parse(_extractedData['data']['campaign']['heartPending']),
          heartReturned: int.parse(_extractedData['data']['campaign']['heartReturned']),
          heartGiven: int.parse(_extractedData['data']['campaign']['heartGiven']),
          premium: int.parse(_extractedData['data']['campaign']['premium']),
        );
        notifyListeners();
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchAvailableCampaign(Media? media) async {
    mInt = media;
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/read_available.php',
        {'media': '$mediaInt', 'author': '$_userId'});

    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      _data.clear();
      throw error;
    });
    if (result.statusCode == 200) {
      final _extractedData = json.decode(result.body) as Map<String, dynamic>;
      if (_extractedData['data'] == null) {
        _data.clear();
      } else {
        _extractedData['data']['campaign'].forEach((value) {
          mString = int.parse(value['media']);
          aString = int.parse(value['action']);
          _data.add(CampaignClass(
            id: int.parse(value['cid']),
            author: int.parse(value['author']),
            authorName: value['authorName'],
            media: stringToMedia,
            action: stringToAction,
            urlImage: value['urlImage'],
            pageUrl: value['pageUrl'],
            qty: int.parse(value['qty']),
            cost: int.parse(value['cost']),
            createdOn: DateFormat("dd/MM/yyyy").parse(value['createdOn']),
            heartPending: int.parse(value['heartPending']),
            heartReturned: int.parse(value['heartReturned']),
            heartGiven: int.parse(value['heartGiven']),
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

  Future<bool> fetchSingleCampaign(int id) async {
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/read_single.php', {'id': '$id'});

    final result = await http.get(_url).catchError((error) {
      throw error;
    });

    ///
    if (result.statusCode == 401) {
      Auth().logout();
    }

    ///
    if (result.statusCode == 200) {
      final _extractedData = json.decode(result.body) as Map<String, dynamic>;
      mString = int.parse(_extractedData['data']['campaign']['media']);
      aString = int.parse(_extractedData['data']['campaign']['action']);
      _singleData = CampaignClass(
        id: int.parse(_extractedData['data']['campaign']['id']),
        author: int.parse(_extractedData['data']['campaign']['author']),
        authorName: _extractedData['data']['campaign']['authorName'],
        media: stringToMedia,
        action: stringToAction,
        urlImage: _extractedData['data']['campaign']['urlImage'],
        pageUrl: _extractedData['data']['campaign']['pageUrl'],
        qty: int.parse(_extractedData['data']['campaign']['qty']),
        cost: int.parse(_extractedData['data']['campaign']['cost']),
        dateString: _extractedData['data']['campaign']['createdOn'],
        heartPending:
        int.parse(_extractedData['data']['campaign']['heartPending']),
        heartReturned:
        int.parse(_extractedData['data']['campaign']['heartReturned']),
        heartGiven: int.parse(_extractedData['data']['campaign']['heartGiven']),
        premium: int.parse(_extractedData['data']['campaign']['premium']),
      );
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> myCampaign() async {
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/my_camp.php', {'user': '$_userId'});

    return await http
        .get(_url, headers: {'authorization': '$_auth'}).then((value) {
      ///
      if (value.statusCode == 401) {
        Auth().logout();
      }

      ///
      final _extractedData = json.decode(value.body) as Map<String, dynamic>;
      if (_extractedData['success'] == false) {
        _data = [];
      } else if (_extractedData['data'] == null) {
        _data = [];
      } else {
        List<CampaignClass> _fetchedData = [];

        _extractedData['data']['campaign'].forEach((value) {
          mString = int.parse(value['media']);
          aString = int.parse(value['action']);
          _fetchedData.add(CampaignClass(
            id: int.parse(value['id']),
            name: value['name'],
            author: int.parse(value['author']),
            authorName: value['authorName'],
            media: stringToMedia,
            action: stringToAction,
            urlImage: value['urlImage'],
            pageUrl: value['pageUrl'],
            qty: int.parse(value['qty']),
            cost: int.parse(value['cost']),
            createdOn: DateFormat("dd/MM/yyyy").parse(value['createdOn']),
            heartPending: int.parse(value['heartPending']),
            heartReturned: int.parse(value['heartReturned']),
            heartGiven: int.parse(value['heartGiven']),
            count: int.parse(value['count']),
          ));
        });
        _data = _fetchedData;
      }
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> next(CampaignClass newData) async {
    if(_data.isNotEmpty && newData.premium == 0){
      _data.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    if(_premiumData.isNotEmpty && newData.premium == 1){
      _premiumData.removeWhere((ele) => ele.id == newData.id);
      notifyListeners();
    }
    final _url = Uri.https('www.likeandshare.app', '/admin/v1/campaign/next.php');

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
    _data.firstWhere((ele) => ele.id == id).heartPending = _pending - _data.firstWhere((ele) => ele.id == id).cost!;
    _data.firstWhere((ele) => ele.id == id).heartGiven = _given + _data.firstWhere((ele) => ele.id == id).cost!;
    notifyListeners();
  }

  void removeData(int? id) {
    if(_data.isNotEmpty){
      _data.removeWhere((ele) => ele.id == id);
      notifyListeners();
    }
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
