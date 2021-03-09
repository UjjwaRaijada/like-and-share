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
                'Freedom Through Education is an initiative by Round Table India. Like & Share proudly supports this initiative.',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.justify,
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
                textAlign: TextAlign.justify,
              ),
              ElevatedButton(
                onPressed: () => _launchURL(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                ),
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
