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
import '../widgets/halfRow.dart';
import '../widgets/bottomButtonPink.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

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
        style: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );

    Widget submitButton = RawMaterialButton(
      onPressed: () => _report(compId),
      child: Text(
        'Submit',
        style: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );

    AlertDialog alert = AlertDialog(
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
      title: Text(
        "Cancellation Reason",
        style: Theme.of(context)
            .textTheme
            .headline1
            .copyWith(color: Theme.of(context).primaryColor),
      ),
      content: Container(
        height: 220,
        child: Column(
          children: [
            Text(
              'Please write your reason below and wait for Admin\'s decision.',
              style: Theme.of(context).textTheme.headline2,
            ),
            Form(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Write here',
                  border: textFormBorder(context),
                  enabledBorder: textFormBorder(context,)
                ),
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
        Navigator.pop(context);
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertBox(
            onPress: () => Navigator.pop(context),
          ),
        );
      }
    });
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
        Provider.of<CompletedData>(context).data.toList();

    actionIcon = _campaignData.action;

    double pending = _campaignData.heartPending / _campaignData.cost < 0 ? 0 : _campaignData.heartPending / _campaignData.cost;

    return StartingCode(
      title: 'Facebook',
      widget: Column(
        children: [
          Row(
            children: [
              HalfRow(
                  title:
                      'Approved: ${(_campaignData.heartGiven / _campaignData.cost).round()}'),
              HalfRow(title: 'Pending: ${pending.round()}'),
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
                    height: 18,
                    child: RawMaterialButton(
                      onPressed: () => _launchURL(_campaignData.pageUrl),
                      child: Text(
                        _campaignData.pageUrl,
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
                              const Text(
                                'Great job! You have shared hearts with people who cared about you. Create a new campaign and enjoy.',
                                textAlign: TextAlign.center,
                              ),
                              const Text('You can also try Refreshing the page!'),
                              const SizedBox(height: 5),
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
          const SizedBox(height: 85),
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