import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './campaignData.dart';

class FAQs {
  final String ques;
  final String ans;

  FAQs({
    this.ques,
    this.ans,
  });
}

class ActionCost {
  final ActionType name;
  final int cost;

  ActionCost({
    this.name,
    this.cost,
  });
}

class Badges {
  final int score;
  final int level;
  final String name;
  final String image;
  final String nextName;
  final int nextScore;

  Badges ({
    this.score,
    this.level,
    this.name,
    this.image,
    this.nextName,
    this.nextScore,
  });
}

List <ActionCost> _actionCostData = [
  ActionCost(name: ActionType.Like, cost: 20),
  ActionCost(name: ActionType.Share, cost: 60),
  ActionCost(name: ActionType.Follow, cost: 100),
  ActionCost(name: ActionType.Retweet, cost: 60),
  ActionCost(name: ActionType.Rate, cost: 60),
  ActionCost(name: ActionType.Love, cost: 20),
  ActionCost(name: ActionType.Subscribe, cost: 160),
  ActionCost(name: ActionType.Review, cost: 100),
];

List<ActionCost> get actionCostData {
  return [..._actionCostData];
}

class Misc extends ChangeNotifier {
  final String _auth;
  final int _user;

  Misc(this._auth, this._user);

  static const String _halfUrl = 'https://www.likeandshare.app/admin/v1';

  Future<bool> sendSuggestion(String suggestion) async {
    final _url = '$_halfUrl/misc/suggestion.php';
    final result = await http
        .post(
      _url,
      headers: {'content-type': 'application/json', 'authorization': '$_auth'},
      body: jsonEncode({
        "user": _user,
        "message": suggestion,
      }),
    )
        .catchError((error) {
      print('misc :: sendSuggestion :: error ::::::::::::::::::: $error');
      throw error;
    });
    if (result.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  List<FAQs> _faqData = [FAQs(ques: '', ans: '')];

  List<FAQs> get faqData {
    return [..._faqData];
  }

  Future<void> faqs() async {
    final _url = '$_halfUrl/misc/faq.php';
    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
      print('misc :: faqs :: error ::::::::::::::::::: $error');
      throw error;
    });

    if (result.statusCode == 200) {
      final _extractedData = jsonDecode(result.body) as Map<String, dynamic>;
      List<FAQs> _fetchedData = [];
      _extractedData['data']['faq'].forEach((value) {
        _fetchedData.add(FAQs(
          ques: value['ques'],
          ans: value['ans'],
        ));
      });
      _faqData = _fetchedData;
      notifyListeners();
    }
  }

  Badges _badgeData = Badges(
    level: 0,
    name: '',
    image: 'https://www.likeandshare.app/admin/v1/badgeImages/NEWBIE.png',
    nextName: '',
    nextScore: 0,
  );
  Badges get badgeData {
    return _badgeData;
  }

  Future<void> getBadge(int score) async {
    print('misc.dart :: getBadge :::::::::::::::::::: getBadge() called');

    final _url = '$_halfUrl/misc/badges.php?score=$score';
    final result = await http.get(
        _url, headers: {'authorization': '$_auth'}).catchError((error) {
      print('misc :: faqs :: error ::::::::::::::::::: $error');
      throw error;
    });
    print('misc.dart :: getBadge :: result :::::::::::::::::: ${jsonDecode(result.body)}');

    if (result.statusCode == 200) {
      final _extractedData = jsonDecode(result.body) as Map<String, dynamic>;
      print('misc.dart :: getBadge :: _extractedData :::::::::::::::::: $_extractedData');

      _badgeData = Badges(
        level: int.parse(_extractedData['data']['badge']['level']),
        name: _extractedData['data']['badge']['name'],
        image: _extractedData['data']['badge']['image'],
        nextName: _extractedData['data']['badge']['nextName'],
        nextScore: int.parse(_extractedData['data']['badge']['nextScore']),
      );
      notifyListeners();
    }
  }

}
