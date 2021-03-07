import 'package:flutter/material.dart';

import '../widgets/startingCode.dart';

class Badge extends StatelessWidget {
  static const String id = 'Badges';

  @override
  Widget build(BuildContext context) {

    return StartingCode(
      title: 'Badge',
      widget: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline3,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200
                  ),
                  child: Image.network('assets/images/beginner.png'),
                ),
                const SizedBox(height: 15),
                Text(
                  'LEVEL 1',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Points :  0',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Text(
                  'The next badge is CURIOUS... upon achieving 10 points',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'If you:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Points',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('Create a campaign'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '+5',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('Recreate a campaign'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '+2',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('Act on a campaign'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '+2',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('File a report against a fake campaign'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '+1',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('File a report against a fake act'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '+1',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('Genuine complain is filed against your campaign'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '-10',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('Genuine complain is filed against your act'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '-10',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text('Fake complain is filed by you'),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '-10',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
