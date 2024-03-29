import 'package:flutter/material.dart';

import './customDivider.dart';

class AlertBox extends StatelessWidget {
  final String title;
  final String? body;
  final Function onPress;

  AlertBox({
    this.title = 'Ooops!',
    this.body = 'Something went wrong! Please try again.',
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFFFFFDD),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(20),
        ),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      title: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Theme.of(context).primaryColor,
            ),
          ),
          CustomDivider(),
        ],
      ),
      content: Container(
        child: Text(
          body!,
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.justify,
        ),
      ),
      actions: [
        Container(
          height: 50,
          child: TextButton(
            onPressed: onPress as void Function()?,
            child: Text(
              'Ok',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
