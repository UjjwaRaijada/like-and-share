import 'package:flutter/material.dart';

class QATile extends StatefulWidget {
  final String? ques;
  final String? ans;
  QATile({
    this.ques,
    this.ans,
  });

  @override
  _QATileState createState() => _QATileState();
}

class _QATileState extends State<QATile> {
  bool _close = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          color: Colors.pinkAccent,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _close = !_close;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.ques!,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                Container(
                  width: 25,
                  child: Icon(
                    _close == true
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        _close == true
            ? const SizedBox(height: 0)
            : Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.pinkAccent,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.ans!,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.justify,
                ),
              ),
        const SizedBox(height: 20),
      ],
    );
  }
}