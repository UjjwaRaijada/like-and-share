import 'package:flutter/material.dart';

import '../widgets/startingCode.dart';

class AboutUs extends StatelessWidget {
  static const String id = 'AboutUs';
  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'About Us',
      widget: Container(
        padding: EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.justify,
            child: Column(
              children: [
                const Text(
                    'Like & Share is about helping others, to get others to help you! “As you sow, so shall you reap” is the belief that drives us...'),
                const SizedBox(height: 10),
                const Text(
                    'This is a platform for all to promote themselves or their business or anything they like. It can be achieved by helping others.'),
                const SizedBox(height: 10),
                const Text(
                    'This platform is completely advertisement free (and we intend to keep it that way always). It is also free to promote your social media pages.'),
                const SizedBox(height: 10),
                const Text(
                    'Other than this, we also offer an option for Paid promotion of campaigns. It is a minimal charge to enable us to keep running this application. This helps us reward the hard working members of our team@Like & Share family who work day & night to ensure a seamless experience for its users.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
