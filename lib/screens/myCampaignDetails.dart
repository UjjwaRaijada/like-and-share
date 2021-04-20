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
  late int _campaignId;
  String? _complain;
  late CampaignClass _campaignData;
  List<Completed> _dataCompleted = [];
  int _tempApprove = 0;
  int _approved = 0;
  int _pending = 0;

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _campaignId = ModalRoute.of(context)!.settings.arguments as int;

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
            .headline2!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );

    Widget submitButton = RawMaterialButton(
      onPressed: () => _report(compId),
      child: Text(
        'Submit',
        style: Theme.of(context)
            .textTheme
            .headline2!
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
            .headline1!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
      content: Container(
        height: 200,
        child: Column(
          children: [
            // Text(
            //   'Please write your reason below and wait for Admin\'s decision.',
            //   style: Theme.of(context).textTheme.headline2,
            // ),
            Form(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Write here',
                  border: textFormBorder(context),
                  enabledBorder: textFormBorder(context,)
                ),
                maxLength: 100,
                minLines: 1,
                maxLines: 4,
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

  void _approve(int compId, int campId) {
    // Provider.of<CampaignData>(context, listen: false).approveCompleted(campId);
    Provider.of<CompletedData>(context, listen: false)
        .approve(compId);
    setState(() {
      _tempApprove += 1;
      _done = true;
    });
    Provider.of<CampaignData>(context, listen: false).approve(campId);
  }

  @override
  Widget build(BuildContext context) {
    _dataCompleted =
        Provider.of<CompletedData>(context).data.toList();
// print(_dataCompleted.length);

    actionIcon = _campaignData.action;
    media = _campaignData.media;
    _approved = (_campaignData.heartGiven! / _campaignData.cost!).round() + _tempApprove;
    _pending = ((_campaignData.heartPending! / _campaignData.cost!) - _tempApprove < 0 ? 0 : (_campaignData.heartPending! / _campaignData.cost!) - _tempApprove).round();

    return StartingCode(
      title: mediaString,
      widget: Column(
        children: [
          Row(
            children: [
              HalfRow(title: 'Approved: $_approved'),
              HalfRow(title: 'Pending: $_pending'),
            ],
          ),
          ShadowBox(
            widget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _campaignData.name!,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 18,
                    child: RawMaterialButton(
                      onPressed: () => _launchURL(_campaignData.pageUrl!),
                      child: Text(
                        _campaignData.pageUrl!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat.yMMMd()
                        .format(_campaignData.createdOn!)
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
                              'Expense: ${_campaignData.cost!*_campaignData.qty!} ',
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
              child: _dataCompleted.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(_dataCompleted[0].userName!),
                        ),
                        Image.network(
                          _dataCompleted[0].screenshot!,
                        ),
                      ],
                    ),
                  )
                : _campaignData.qty! * _campaignData.cost! > _campaignData.heartPending! + _campaignData.heartGiven! + _campaignData.heartReturned!
                  ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyText1!,
                      textAlign: TextAlign.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _campaignData.qty! * _campaignData.cost! != _campaignData.heartPending! + _campaignData.heartReturned! + _campaignData.heartGiven!
                              ? const Text('Your Campaign is still active. Please wait for people to act on your Campaign.')
                              : const Text(
                            'Great job! You have shared hearts with people who cared about you. Create a new campaign and enjoy.',
                          ),
                          const SizedBox(height: 3),
                          const Text('You can also try Refreshing the page!'),
                          const SizedBox(height: 10),
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
                  : Center(
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
                  ),
            ),
          const SizedBox(height: 85),
        ],
      ),
      bottomS: _dataCompleted.isNotEmpty
        ? Container(
          height: 80,
          color: Colors.white70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomButtonPink(
                onPress: _done == false ? (){}
                    :() => _reportAlert(_dataCompleted[0].id!),
                icon: FontAwesomeIcons.solidFlag,
                label: 'Report',
              ),
              BottomButtonPink(
                onPress: _done == false ? (){}
                    :() {
                  setState(() {
                    _done = false;
                  });
                  _approve(_dataCompleted[0].id!, _dataCompleted[0].campaignId!);
                },
                icon: FontAwesomeIcons.check,
                label: 'Approve',
              ),
            ],
          ),
        )
        : SizedBox(height: 0),
    );
  }
}