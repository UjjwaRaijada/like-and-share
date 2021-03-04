import 'package:flutter/material.dart';

import '../widgets/startingCode.dart';

class BuyHearts extends StatelessWidget {
  static const String id = 'BuyHearts';
  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'Buy Hearts',
      widget: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'Sorry! Currently we are not selling Heart Points. But, you can earn more Hearts by participating in campaigns run by others.',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
