import 'package:flutter/material.dart';

import '../widgets/startingCode.dart';
import '../widgets/customDivider.dart';

class Badges extends StatelessWidget {
  static const String id = 'Badges';

  @override
  Widget build(BuildContext context) {

    return StartingCode(
      title: 'History',
      widget: DefaultTextStyle(
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Level 1',
                      style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Points: 0',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Start using this app and earn your first badge!')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
