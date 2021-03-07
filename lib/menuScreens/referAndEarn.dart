import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

import '../widgets/startingCode.dart';
import '../providers/myProfile.dart';

class ReferAndEarn extends StatelessWidget {
  static const String id = 'ReferAndEarn';

  final String _message =
      'Hey! I am promoting my Social Media page for FREE!  Use my referral code and get extra Heart points!!!';

  @override
  Widget build(BuildContext context) {
    String _code =
        'Referral Code : ${Provider.of<MyProfileData>(context).data.mobile}';
    return StartingCode(
      title: 'Refer & Earn',
      widget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sharing is caring and we appreciate when you care about someone. As a token of appreciation we will give you & your loved one extra Heart points.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.pinkAccent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyText1,
                child: Column(
                  children: [
                    const Text('Message:'),
                    const SizedBox(height: 10),
                    Text(
                      _message,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _code,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomS: RawMaterialButton(
        onPressed: () {
          Share.share('$_message \n $_code');
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Share',
              style: Theme.of(context).textTheme.button.copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
