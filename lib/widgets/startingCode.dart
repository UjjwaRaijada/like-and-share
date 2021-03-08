import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/myProfile.dart';

class StartingCode extends StatelessWidget {
  final Widget widget;
  final bool backButton;
  final String title;
  final Widget bottomS;
  final Widget floatingButton;
  StartingCode({
    this.widget,
    this.backButton = true,
    this.title,
    this.bottomS = const SizedBox(height: 0),
    this.floatingButton,
  });

  @override
  Widget build(BuildContext context) {
    int _userHearts = Provider.of<MyProfileData>(context).data.hearts;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            colors: const [Color(0xFFFF8967), Color(0xFFFF64A4)],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Column(children: [
          SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: backButton == true
                      ? RawMaterialButton(
                          child: const Icon(
                            Icons.arrow_left,
                            color: Colors.pink,
                            size: 40,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      : const SizedBox(),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    children: [
                      Text(
                        _userHearts > 999
                        ? (_userHearts / 1000).toStringAsFixed(1) + 'K '
                        : '$_userHearts ',
                        // '${_myProfile.hearts}',
                        style:
                            const TextStyle(color: Colors.pink, fontSize: 20),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                ),
              ),
              child: widget,
            ),
          ),
        ]),
      ),
      bottomSheet: bottomS,
      floatingActionButton: floatingButton,
    );
  }
}
