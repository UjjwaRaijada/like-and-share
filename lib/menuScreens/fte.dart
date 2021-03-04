import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/startingCode.dart';

class FTE extends StatelessWidget {
  static const String id = 'FTE';

  void _launchURL() async {
    String url = 'https://www.roundtableindia.org';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'FTE',
      widget: Container(
        padding: EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Freedom Through Education is an initiative by Round Table India. ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/fte.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'To be part of this initiative, visit Round Table India website by clicking the link below.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              RaisedButton(
                onPressed: () => _launchURL(),
                color: Colors.pinkAccent,
                child: Text(
                  'Visit Website',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
