import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../screens/historyDetails.dart';
import '../providers/myProfile.dart';
import '../providers/campaignData.dart';
import '../providers/completed.dart';
import '../widgets/startingCode.dart';
import '../widgets/shadowBox.dart';
import '../widgets/customDivider.dart';

class History extends StatefulWidget {
  static const String id = 'History';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _spinner = false;
  List<Completed> _data;

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_spinner == true) {
      Provider.of<CompletedData>(context, listen: false)
          .myHistory()
          .then((value) {
        if (value == false) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text('Something went wrong. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ],
            ),
          ).then((_) => Navigator.pop(context));
        } else {
          _data = Provider.of<CompletedData>(context, listen: false)
              .data
              .where((ele) =>
                  (24 * 60 -
                      DateTime.now().difference(ele.submitDate).inMinutes) >
                  0)
              .toList();
          setState(() {
            _spinner = false;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'History',
      widget: _spinner == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(

              children: [
                Text(
                  'Hearts to be Received: ${Provider.of<MyProfileData>(context).data.holdIn}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                CustomDivider(),
                _data.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(25),
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyText1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Support a campaign and get rewarded.',
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'To support a campaign, click on any social media icon on the home page.',
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                  'Click on the campaign you want to support & get heart points as reward.'),
                              const SizedBox(height: 10),
                              const Text(
                                  'You can use these heart points to promote your social media pages.'),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            mString = _data[index].media;
                            Media _media = stringToMedia;
                            mediaImage = _media;
                            String _mediaUrl = mediaToImage;

                            aString = _data[index].action;
                            ActionType _action = stringToAction;
                            actionIcon = _action;
                            IconData _icon = actionToIcon;

                            int _diffTime = DateTime.now()
                                .difference(_data[index].submitDate)
                                .inMinutes;
                            int _minLeft = 24 * 60 - _diffTime;
                            int _hourL = (_minLeft ~/ 60).toInt();
                            int _minL = _minLeft % 60;
                            String _hour;
                            String _min;

                            if (_hourL < 10) {
                              _hour = '0$_hourL';
                            } else {
                              _hour = '$_hourL';
                            }
                            if (_minL < 10) {
                              _min = '0$_minL';
                            } else {
                              _min = '$_minL';
                            }
                            return HistoryTile(
                              compId: _data[index].id,
                              url: _data[index].pageUrl,
                              snippetUrl: _data[index].screenshot,
                              mediaUrl: _mediaUrl,
                              iconForAction: _icon,
                              author: _data[index].userName,
                              heart: _data[index].cost,
                              days: '$_hour:$_min',
                            );
                          },
                          itemCount: _data.length,
                        ),
                      ),
              ],
            ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final int compId;
  final String url;
  final String author;
  final String snippetUrl;
  final String mediaUrl;
  final IconData iconForAction;
  final int heart;
  final String days;

  HistoryTile({
    this.compId,
    this.url,
    this.author,
    this.snippetUrl,
    this.mediaUrl,
    this.iconForAction,
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
              Navigator.pushNamed(context, HistoryDetails.id,
                  arguments: compId);
            },
            child: Tooltip(
              message: 'Copied',
              child: ShadowBox(
                widget: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.network(snippetUrl),
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
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            child: Text(
                              url,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 15,
                                  child: Image.asset(mediaUrl),
                                ),
                                Icon(
                                  iconForAction,
                                  size: 15,
                                  color: Colors.pinkAccent,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      heart.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    const Icon(
                                      Icons.favorite,
                                      size: 15,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                Text(
                                  '$days hrs',
                                  style: Theme.of(context).textTheme.headline2,
                                )
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
