import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/socialMediaDetails.dart';
import '../widgets/shadowBox.dart';

class SocialMediaTile extends StatelessWidget {
  final String id;
  final String url;
  final String author;
  final String snippetUrl;
  final IconData icon;
  final int heart;
  final int days;

  SocialMediaTile({
    this.id,
    this.url,
    this.author,
    this.snippetUrl,
    this.icon,
    this.heart,
    this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: url),
              );
              Navigator.pushNamed(context, SocialMediaDetails.id);
            },
            child: Tooltip(
              message: 'Copied',
              child: ShadowBox(
                widget: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        snippetUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 20,
                            child: Text(
                              author,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            child: Text(
                              url,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                id == 'History'
                                    ? Container(
                                        height: 20,
                                        child: Image.asset(
                                            'assets/images/facebook.png'),
                                      )
                                    : const SizedBox(),
                                Icon(icon),
                                Row(
                                  children: [
                                    Text(heart.toString()),
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                    ),
                                  ],
                                ),
                                Text('$days days')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: const Divider(
            height: 3,
            color: Colors.pinkAccent,
          ),
        ),
      ],
    );
  }
}
