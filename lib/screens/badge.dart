import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/misc.dart';
import '../providers/myProfile.dart';
import '../widgets/startingCode.dart';

class Badge extends StatelessWidget {
  static const String id = 'Badges';

  @override
  Widget build(BuildContext context) {
    int _score = Provider.of<MyProfileData>(context).data.score;
    Badges _data = Provider.of<Misc>(context).badgeData;
    if(_data.level == 0) {
      Provider.of<Misc>(context, listen: false).getBadge(_score);
    }

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
                  constraints: const BoxConstraints(
                    maxHeight: 200
                  ),
                  child: _data == null
                    ? Image.asset('assets/images/NOVICE.png')
                    : Image.network(_data.image),
                ),
                const SizedBox(height: 15),
                Text(
                  'LEVEL ${_data.level}',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Points :  $_score',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Text(
                  'The next badge is ${_data.nextName}... upon achieving ${_data.nextScore} points',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'If you:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Points',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: const Text('Create a campaign'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
                      child: const Text('Recreate a campaign'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
                      child: const Text('Act on a campaign'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
                      child: const Text('File a report against a fake campaign'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
                      child: const Text('File a report against a fake act'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
                        '+1',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: const Text('Genuine complain is filed against your campaign'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
                      child: const Text('Genuine complain is filed against your act'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
                      child: const Text('Fake complain is filed by you'),
                    ),
                    Container(
                      width: 40,
                      child: const Text(
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
