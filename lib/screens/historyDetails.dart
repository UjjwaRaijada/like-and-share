import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/campaignData.dart';
import '../providers/completed.dart';
import '../widgets/startingCode.dart';
import '../widgets/shadowBox.dart';

class HistoryDetails extends StatefulWidget {
  static const String id = 'HistoryDetails';

  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  bool _spinner;
  CampaignClass _data;
  Completed _complete;
  String _hour;
  String _min;

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  didChangeDependencies() {
    if (_spinner == true) {
      int _compId = ModalRoute.of(context).settings.arguments;
      _complete = Provider.of<CompletedData>(context, listen: false)
          .data
          .firstWhere((val) => val.id == _compId);
      Provider.of<CampaignData>(context, listen: false)
          .fetchSingleCampaign(_complete.campaignId)
          .then((value) {
        _data = Provider.of<CampaignData>(context, listen: false).singleData;
      }).then((_) {
        actionIcon = _data.action;
        media = _data.media;

        int _diffTime =
            DateTime.now().difference(_complete.submitDate).inMinutes;
        int _minLeft = 24 * 60 - _diffTime;
        int _hourL = (_minLeft ~/ 60).toInt();
        int _minL = _minLeft % 60;

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
      }).then((_) {
        setState(() {
          _spinner = false;
        });
      }).catchError((error) {
        print(error);
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    mediaString,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                ShadowBox(
                  widget: Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: Image.network(_data.urlImage),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _data.authorName,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  Text(
                                    _data.pageUrl,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        actionToIcon,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _data.cost.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                      const FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$_hour:$_min hrs',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Image.network(_complete.screenshot),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
