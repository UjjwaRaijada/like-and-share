import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FAQs {
  final String ques;
  final String ans;

  FAQs({
    this.ques,
    this.ans,
  });
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
}
