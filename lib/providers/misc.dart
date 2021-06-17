import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class FAQs {
  final String? ques;
  final String? ans;

  FAQs({
    this.ques,
    this.ans,
  });
}

String? actionIcon;
IconData get stringToAction {
  switch (actionIcon) {
    case 'Like':
      return FontAwesomeIcons.solidThumbsUp;
    case 'Share':
      return FontAwesomeIcons.shareAlt;
    case 'Follow':
      return FontAwesomeIcons.user;
    case 'Rate':
      return FontAwesomeIcons.solidStar;
    case 'Subscribe':
      return FontAwesomeIcons.solidBell;
    case 'Review':
      return FontAwesomeIcons.penFancy;
    default:
      return FontAwesomeIcons.question;
  }
}

class ActionCost {
  final int id;
  final String name;
  final int cost;

  ActionCost({
    required this.id,
    required this.name,
    required this.cost,
  });
}

class Badges {
  final int? score;
  final int? level;
  final String? name;
  final String? image;
  final String? nextName;
  final int? nextScore;

  Badges ({
    this.score,
    this.level,
    this.name,
    this.image,
    this.nextName,
    this.nextScore,
  });
}


class Misc extends ChangeNotifier {
  final String? _auth;
  final int? _user;
  Misc(this._auth, this._user);

  String _website = 'www.likeandshare.app';
  String _address = '/admin/v2/misc/';

  List <ActionCost> _actionCostData = [];

  List<ActionCost> get actionCostData {
    return [..._actionCostData];
  }

  Future<int> actionCost() async {
    final _url = Uri.https(_website, '$_address/actionCost.php');

    final result = await http.get(
      _url,
      headers: {'content-type': 'application/json', 'authorization': '$_auth'},
    );
print(jsonDecode(result.body));
    if(result.statusCode == 200) {
      final _extData = jsonDecode(result.body) as Map<String, dynamic>;
      List<ActionCost> _newData = [];
      _extData['data']['misc'].forEach((val) {
        _newData.add(ActionCost(
          id: int.parse(val['id']),
          name: val['name'],
          cost: int.parse(val['hearts']),
        ));
      });
      _actionCostData = _newData;
      notifyListeners();
    }
    return result.statusCode;
  }

  Future<bool> sendSuggestion(String? suggestion) async {
    final _url = Uri.https(_website, '$_address/suggestion.php');

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
    final _url = Uri.https(_website, '$_address/faq.php');

    final result = await http
        .get(_url, headers: {'authorization': '$_auth'}).catchError((error) {
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
    image: 'https:/_website/admin/v2/badgeImages/NEWBIE.png',
    nextName: '',
    nextScore: 0,
  );
  Badges get badgeData {
    return _badgeData;
  }

  Future<void> getBadge(int? score) async {
    final _url = Uri.https(_website, '$_address/badges.php', {'score': '$score'});

    final result = await http.get(
        _url, headers: {'authorization': '$_auth'}).catchError((error) {
      throw error;
    });

    if (result.statusCode == 200) {
      final _extractedData = jsonDecode(result.body) as Map<String, dynamic>;

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

  Future<String> getDisclaimer() async {
    final _url = Uri.https(_website, '$_address/disclaimer.php');

    final result = await http.get(_url).catchError((error) {
      throw error;
    });
    if (result.statusCode == 200) {
      final _extractedData = jsonDecode(result.body) as Map<String, dynamic>;
      final _disclaimerData = _extractedData['data']['disclaimer']['disclaimer'];
    return _disclaimerData;
    } else {
      return '';
    }
  }

}
