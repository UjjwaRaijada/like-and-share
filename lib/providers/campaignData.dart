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

Media media;
String get mediaString {
  switch (media) {
    case Media.Facebook:
      return 'Facebook';
      break;
    case Media.Instagram:
      return 'Instagram';
      break;
    case Media.Twitter:
      return 'Twitter';
      break;
    case Media.YouTube:
      return 'YouTube';
      break;
    case Media.GoogleReview:
      return 'Google Review';
      break;
    default:
      return 'unknown';
  }
}

Media mInt;
int get mediaInt {
  switch (mInt) {
    case Media.Facebook:
      return 1;
      break;
    case Media.Instagram:
      return 2;
      break;
    case Media.Twitter:
      return 3;
      break;
    case Media.YouTube:
      return 4;
      break;
    case Media.GoogleReview:
      return 5;
      break;
    default:
      return 0;
  }
}

int mString;
Media get stringToMedia {
  switch (mString) {
    case 1:
      return Media.Facebook;
      break;
    case 2:
      return Media.Instagram;
      break;
    case 3:
      return Media.Twitter;
      break;
    case 4:
      return Media.YouTube;
      break;
    case 5:
      return Media.GoogleReview;
      break;
    default:
      return Media.GoogleReview;
  }
}

Media mediaImage;
String get mediaToImage {
  switch (mediaImage) {
    case Media.Facebook:
      return 'assets/images/facebook.png';
      break;
    case Media.Instagram:
      return 'assets/images/instagram.png';
      break;
    case Media.Twitter:
      return 'assets/images/twitter.png';
      break;
    case Media.YouTube:
      return 'assets/images/youtube.png';
      break;
    case Media.GoogleReview:
      return 'assets/images/google.png';
      break;
    default:
      return 'assets/images/unknown.png';
  }
}

ActionType action;
String get actionString {
  switch (action) {
    case ActionType.Like:
      return 'Like';
      break;
    case ActionType.Share:
      return 'Share';
      break;
    case ActionType.Follow:
      return 'Follow';
      break;
    case ActionType.Love:
      return 'Like';
      break;
    case ActionType.Retweet:
      return 'Retweet';
      break;
    case ActionType.Review:
      return 'Review';
      break;
    case ActionType.Subscribe:
      return 'Subscribe';
      break;
    case ActionType.Rate:
      return 'Rating';
      break;
    default:
      return 'unknown';
  }
}

ActionType aInt;
int get actionInt {
  switch (aInt) {
    case ActionType.Like:
      return 1;
      break;
    case ActionType.Share:
      return 2;
      break;
    case ActionType.Follow:
      return 3;
      break;
    case ActionType.Love:
      return 4;
      break;
    case ActionType.Retweet:
      return 5;
      break;
    case ActionType.Review:
      return 6;
      break;
    case ActionType.Subscribe:
      return 7;
      break;
    case ActionType.Rate:
      return 8;
      break;
    default:
      return 0;
  }
}

int aString;
ActionType get stringToAction {
  switch (aString) {
    case 1:
      return ActionType.Like;
      break;
    case 2:
      return ActionType.Share;
      break;
    case 3:
      return ActionType.Follow;
      break;
    case 4:
      return ActionType.Retweet;
      break;
    case 5:
      return ActionType.Rate;
      break;
    case 6:
      return ActionType.Love;
      break;
    case 7:
      return ActionType.Subscribe;
      break;
    case 8:
      return ActionType.Review;
      break;
    default:
      return ActionType.Like;
  }
}

ActionType actionIcon;
IconData get actionToIcon {
  switch (actionIcon) {
    case ActionType.Like:
      return FontAwesomeIcons.thumbsUp;
      break;
    case ActionType.Share:
      return FontAwesomeIcons.shareAlt;
      break;
    case ActionType.Follow:
      return FontAwesomeIcons.users;
      break;
    case ActionType.Love:
      return FontAwesomeIcons.thumbsUp;
      break;
    case ActionType.Retweet:
      return FontAwesomeIcons.retweet;
      break;
    case ActionType.Review:
      return FontAwesomeIcons.penFancy;
      break;
    case ActionType.Subscribe:
      return FontAwesomeIcons.bell;
      break;
    case ActionType.Rate:
      return FontAwesomeIcons.solidStar;
      break;
    default:
      return FontAwesomeIcons.question;
  }
}

class CampaignClass {
  final int id;
  final String name;
  final int author;
  final String authorName;
  final Media media;
  final ActionType action;
  final String urlImage;
  final String pageUrl;
  final int qty;
  final int cost;
  final String dateString;
  final DateTime createdOn;
  final int heartPending;
  final int heartGiven;
  final int heartReturned;
  final int premium;

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
  });
}

class CampaignData with ChangeNotifier {
  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';
  int chosenId;
  List<CampaignClass> _data = [];

  List<CampaignClass> get data {
    return [..._data];
  }

  List<CampaignClass> _premiumData = [];

  List<CampaignClass> get premiumData {
    return [..._premiumData];
  }

  CampaignClass _singleData;

  CampaignClass get singleData {
    return _singleData;
  }

  final String _auth;
  final _user;
  CampaignData(this._auth, this._user, this._data);

  Future<bool> premiumCamp() async {
    final _url = '$_halfUrl/campaign/read_premium.php?author=$_user';
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

    const _url = '$_halfUrl/campaign/create.php';
    // const _urlImage = '$_halfUrl/campaign/create_image.php';
    // bool status;

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
        "author": _user,
        "name" : newData.name,
        "media": mediaInt,
        "action": actionInt,
        "pageUrl": newData.pageUrl,
        "qty": newData.qty,
        "cost": newData.cost,
      }),
    ).catchError((error) {
      print('campaignData.dart :: createCampaign :: error :::::::::::::::::::::::::: $error');
      throw error;
    });
    print('campaignData.dart :: createCampaign :: result :::::::::::::::::::::::::: ${result.body}');
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
    final _url = '$_halfUrl/campaign/read.php?media=$mediaInt&author=$_user';

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
    // print('completed.dart :: screenshot :::::::::::: ${newData.screenshot}');
    const _url = '$_halfUrl/completed/create.php';
    const _urlImage = '$_halfUrl/completed/create_image.php';

    var request = http.MultipartRequest("POST", Uri.parse(_urlImage));
    var pic =
    await http.MultipartFile.fromPath('imagefile', newData.urlImage);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print('campaignData.dart :: createCompleted :: responseString ::::::::::::::::::::::: $responseString');

    final result = await http
        .post(
      _url,
      headers: {'content-type': 'application/json', 'authorization': '$_auth'},
      body: json.encode({
        'campaign': newData.id,
        'author': newData.author,
        'user': _user,
        'screenshot': responseString,
      }),
    ).catchError((error) {
      print('campaignData.dart :: createCompleted :: error ::::::::::::::::::::::: $error');
    });
    print('campaignData.dart :: createCompleted :: response ::::::::::::::::::::::: ${result.body}');
    ///
    if (result.statusCode == 401) {
      Auth().logout();
    }
    ///
    if (result.statusCode == 201) {
      print('201');
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
      print('false');
      return false;
    }
  }

  Future<void> fetchAvailableCampaign(Media media) async {
    mInt = media;
    final _url = '$_halfUrl/campaign/read_available.php?media=$mediaInt&author=$_user';

    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      _data.clear();
      throw error;
    });
    if (result.statusCode == 200) {
      final _extractedData = json.decode(result.body) as Map<String, dynamic>;
      print('campaignData.dart :: fetchAvailableCampaign :: _extractedData :::::::::::::::::: $_extractedData');
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
    final _url = '$_halfUrl/campaign/read_single.php?id=$id';

    final result = await http.get(_url).catchError((error) {
      print('campaignData.dart :: fetchSingleCampaign :: error ::::::::::: $error');
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
    final _url = '$_halfUrl/campaign/my_camp.php?user=$_user';

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
          ));
        });
        _data = _fetchedData;
      }
      notifyListeners();
    }).catchError((error) {
      print('error is :::::: $error');
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
    print('completed.dart :: next :::::::::::::::::::::::: next called');
    const _url = '$_halfUrl/completed/next.php';
    final result = await http.post(
        _url,
        headers: {'content-type': 'application/json', 'authorization': '$_auth'},
        body: jsonEncode({
          'campaign': newData.id,
          'author': newData.author,
          'user': _user,
        })
    ).catchError((error) {
      print('completed.dart :: next :: error :::::::::::::::::::::: $error');
      throw error;
    });
    print('completed.dart :: next :: response :::::::::::::::::::::: ${jsonDecode(result.body)}');
  }

  void removeData(int id) {
    if(_data.isNotEmpty){
      _data.removeWhere((ele) => ele.id == id);
      notifyListeners();
    }
  }
  void removeDataPremium(int id) {
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
