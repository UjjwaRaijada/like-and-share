import 'package:flutter/material.dart';

import '../widgets/startingCode.dart';

class HistoryNew extends StatelessWidget {
  static const String id = 'HistoryNew';

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('521',
                      style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.favorite,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total No. of Campaigns Supported :'),
                        const SizedBox(width: 20),
                        Text('10'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Hearts Earned :'),
                        const SizedBox(width: 20),
                        Text('10'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Hearts Pending to be Received :'),
                        const SizedBox(width: 20),
                        Text('10'),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Campaigns Created :'),
                        const SizedBox(width: 20),
                        Text('10'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Hearts Spent :'),
                        const SizedBox(width: 20),
                        Text('10'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
