import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import './restartCampaign.dart';
import '../providers/campaignData.dart';
import '../providers/completed.dart';
import '../widgets/startingCode.dart';
import '../widgets/shadowBox.dart';
import '../widgets/customDivider.dart';
import '../widgets/halfRow.dart';
import '../widgets/bottomButtonPink.dart';

class MyCampaignDetails extends StatefulWidget {
  static const String id = 'MyCampaignDetails';

  @override
  _MyCampaignDetailsState createState() => _MyCampaignDetailsState();
}

class _MyCampaignDetailsState extends State<MyCampaignDetails> {
  bool _spinner = false;
  bool _done = true;
  int _campaignId;
  String _complain;
  CampaignClass _campaignData;
  List<Completed> _dataCompleted = [];

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _campaignId = ModalRoute.of(context).settings.arguments;
    _campaignData = Provider.of<CampaignData>(context, listen: false)
        .data
        .firstWhere((val) => val.id == _campaignId);
    if (_spinner == true) {
      Provider.of<CompletedData>(context, listen: false)
          .read(_campaignId)
          .then((_) {
        setState(() {
          _spinner = false;
        });
      }).catchError((error) {
        print('error :::::::::::::::::::: $error');
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  void _launchURL(String val) async {
    if (await canLaunch(val)) {
      await launch(val);
    } else {
      throw 'Could not launch $val';
    }
  }

  // void _showImage(Completed complete) {
  //   Widget okButton = RawMaterialButton(
  //     onPressed: () {
  //       _approve(complete.id);
  //       Navigator.pop(context);
  //     },
  //     constraints: const BoxConstraints(
  //       maxWidth: 30,
  //       minWidth: 30,
  //       maxHeight: 30,
  //       minHeight: 30,
  //     ),
  //     child: const FaIcon(
  //       FontAwesomeIcons.check,
  //       size: 18,
  //       color: Colors.white,
  //     ),
  //     fillColor: Colors.green,
  //     shape: const CircleBorder(),
  //   );
  //
  //   Widget cancelButton = RawMaterialButton(
  //     onPressed: () {
  //       Navigator.pop(context);
  //       _cancelAlert(complete);
  //     },
  //     constraints: const BoxConstraints(
  //       maxWidth: 30,
  //       minWidth: 30,
  //       maxHeight: 30,
  //       minHeight: 30,
  //     ),
  //     child: const FaIcon(
  //       FontAwesomeIcons.times,
  //       size: 20,
  //       color: Colors.white,
  //     ),
  //     fillColor: Colors.red,
  //     shape: const CircleBorder(),
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(
  //       complete.userName,
  //       style: Theme.of(context).textTheme.headline1,
  //     ),
  //     content: Container(
  //       height: 250,
  //       width: 250,
  //       child: Image.network(complete.screenshot),
  //     ),
  //     actions: [okButton, cancelButton],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  void refreshPage() {
    setState(() {
      _spinner = true;
    });
    if (_spinner == true) {
      Provider.of<CompletedData>(context, listen: false)
          .read(_campaignId)
          .then((_) {
        _dataCompleted =
            Provider.of<CompletedData>(context, listen: false).data.toList();
        setState(() {
          _spinner = false;
        });
      }).catchError((error) {
        print('error :::::::::::::::::::: $error');
        setState(() {
          _spinner = false;
        });
      });
    }
  }

  void _reportAlert(int compId) {
    Widget backButton = RawMaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Back',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );

    Widget submitButton = RawMaterialButton(
      onPressed: () => _report(compId),
      child: Text(
        'Submit',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Cancellation Reason",
        style: Theme.of(context).textTheme.headline1,
      ),
      content: Container(
        height: 220,
        child: Column(
          children: [
            Text(
              'Please write your reason below and wait for Admin\s decision.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Form(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Write here'),
                maxLength: 150,
                minLines: 1,
                maxLines: 10,
                onChanged: (val) => _complain = val,
              ),
            ),
          ],
        ),
      ),
      actions: [backButton, submitButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _report(int id) {
    Provider.of<CompletedData>(context, listen: false)
        .cancel(id, _complain)
        .then((value) {
      if (value == true) {
        refreshPage();
      } else {
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
        );
      }
    });
    Navigator.pop(context);
  }

  void _approve(int compId) {
    // Provider.of<CampaignData>(context, listen: false).approveCompleted(campId);
    Provider.of<CompletedData>(context, listen: false)
        .approve(compId);
    setState(() {
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataCompleted =
        Provider.of<CompletedData>(context, listen: false).data.toList();

    actionIcon = _campaignData.action;

    return StartingCode(
      title: 'Facebook',
      widget: Column(
        children: [
          Row(
            children: [
              HalfRow(
                  title:
                      'Approved: ${(_campaignData.heartGiven / _campaignData.cost).round()}'),
              HalfRow(title: 'Pending: ${(_campaignData.heartPending / _campaignData.cost).round()}'),
            ],
          ),
          ShadowBox(
            widget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _campaignData.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 16,
                    child: RawMaterialButton(
                      onPressed: () => _launchURL(_campaignData.pageUrl),
                      child: Text(
                        _campaignData.pageUrl,
                        // style: const TextStyle(
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.bold,
                        // ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat.yMMMd()
                        .format(_campaignData.createdOn)
                        .toString(),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              'Target: ${_campaignData.qty} ',
                              // style:
                              //     Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          Icon(
                            actionToIcon,
                            size: 12,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'Expense: ${_campaignData.cost*_campaignData.qty} ',
                              // style:
                              //     Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Row(
          //   children: [
          //     HalfRow(title: 'Shared: 32 Hearts'),
          //     HalfRow(title: 'Pending: 80 Hearts '),
          //   ],
          // ),
          _spinner == true
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Expanded(
                    child: _dataCompleted == null
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, RestartCampaign.id,
                                  arguments: _campaignData.id),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                              ),
                              child: Text(
                                'Restart Campaign',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          )
                        : _dataCompleted.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: DefaultTextStyle(
                                style: Theme.of(context).textTheme.bodyText1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Great job! You have shared hearts with people who cared about you. Create a new campaign and enjoy.',
                                      textAlign: TextAlign.center,
                                    ),
                                    Text('You can also try Refreshing the page!'),
                                    SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () => refreshPage(),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor
                                        ),
                                      ),
                                      child: Text('Refresh Page',
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            // : ListView.builder(
                            //     padding: EdgeInsets.zero,
                            //     itemBuilder: (context, index) {
                            //       int _diffTime = DateTime.now()
                            //           .difference(
                            //               _dataCompleted[index].submitDate)
                            //           .inMinutes;
                            //       int _minLeft = 24 * 60 - _diffTime;
                            //       int _hourL = (_minLeft ~/ 60).toInt();
                            //       int _minL = _minLeft % 60;
                            //       String _hour;
                            //       String _min;
                            //
                            //       if (_hourL < 10) {
                            //         _hour = '0$_hourL';
                            //       } else {
                            //         _hour = '$_hourL';
                            //       }
                            //       if (_minL < 10) {
                            //         _min = '0$_minL';
                            //       } else {
                            //         _min = '$_minL';
                            //       }
                            //       return Tile(
                            //         onPress: () =>
                            //             _showImage(_dataCompleted[index]),
                            //         onPressOk: () {
                            //           _approve(_dataCompleted[index].id);
                            //         },
                            //         name: _dataCompleted[index].userName,
                            //         days: '$_hour:$_min',
                            //       );
                            //     },
                            //     itemCount: _dataCompleted.length,
                            //   ),
                          : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(_dataCompleted[0].userName),
                                ),
                                Image.network(
                                    _dataCompleted[0].screenshot,
                                ),
                              ],
                            ),
                          ),
                  ),
          SizedBox(height: 85),
        ],
      ),
      bottomS: Container(
        height: 80,
        color: Colors.white70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomButtonPink(
              onPress: _done == false ? (){}
                  :() => _reportAlert(_dataCompleted[0].id),
              icon: FontAwesomeIcons.solidFlag,
              label: 'Report',
            ),
            BottomButtonPink(
              onPress: _done == false ? (){}
                  :() {
                setState(() {
                  _done = false;
                });
                _approve(_dataCompleted[0].id);
              },
              icon: FontAwesomeIcons.check,
              label: 'Approve',
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final Function onPress;
  final Function onPressOk;
  final String name;
  final String days;

  Tile({
    this.onPress,
    this.onPressOk,
    this.name,
    this.days,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RawMaterialButton(
                onPressed: onPress,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.headline2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      'Time Left: $days hrs',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  RawMaterialButton(
                    onPressed: onPress,
                    constraints: BoxConstraints(
                      maxWidth: 30,
                      minWidth: 30,
                      maxHeight: 30,
                      minHeight: 30,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      size: 18,
                      color: Colors.white,
                    ),
                    fillColor: Colors.blueAccent,
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: onPressOk,
                    constraints: BoxConstraints(
                      maxWidth: 30,
                      minWidth: 30,
                      maxHeight: 30,
                      minHeight: 30,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                    fillColor: Colors.green,
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomDivider(),
      ],
    );
  }
}
