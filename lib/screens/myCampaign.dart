import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './myCampaignDetails.dart';
import '../providers/campaignData.dart';
import '../widgets/customDivider.dart';
import '../widgets/halfRow.dart';
import '../widgets/shadowBox.dart';
import '../widgets/startingCode.dart';

class MyCampaign extends StatefulWidget {
  static const String id = 'MyCampaign';

  @override
  _MyCampaignState createState() => _MyCampaignState();
}

class _MyCampaignState extends State<MyCampaign> {
  List<CampaignClass> _data = [];
  bool _spinner = false;

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
      Provider.of<CampaignData>(context, listen: false).myCampaign().then((_) {
      }).then((_) {
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _data = Provider.of<CampaignData>(context, listen: false).data;

    return StartingCode(
      title: 'My Campaign',
      widget: _spinner == true
        ? Center(child: CircularProgressIndicator())
        : _data.isEmpty
          ? Padding(
            padding: const EdgeInsets.all(18.0),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    const Text(
                      'Support a campaign and get rewarded.',
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'To support a campaign, click on any social media icon on the home page.',
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        'Do Like or Share or other action as per requested and click Done.'),
                    const SizedBox(height: 10),
                    const Text(
                        'You can use these heart points to promote your social media pages.'),
                  ],
                ),
            ),
          )
          : Column(
              children: [
                Row(
                  children: [
                    HalfRow(
                      title: 'Total: ${_data.length}',
                    ),
                    HalfRow(
                      title: 'Running: ${_data.where((ele) => ele.qty * ele.cost != ele.heartPending + ele.heartGiven + ele.heartReturned).length}',
                    ),
                  ],
                ),
                CustomDivider(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      actionIcon = _data[index].action;
                      media = _data[index].media;
                      action = _data[index].action;

                      return SocialMediaTile(
                        backColor: _data[index].heartPending > 0
                          ? Colors.red.withOpacity(0.2)
                          : Colors.transparent,
                        campaignId: _data[index].id,
                        name: _data[index].name,
                        date: _data[index].createdOn,
                        totalAction: _data[index].count,
                        actionQty: _data[index].qty,
                        actionPending: (_data[index].heartPending / _data[index].cost ) > 0
                          ? (_data[index].heartPending / _data[index].cost).round()
                          : 0
                        // imageUrl: _data[index].urlImage,
                        // action: _data[index].action,
                        // costPerAction: _data[index].cost * _data[index].qty,
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

class SocialMediaTile extends StatelessWidget {
  final Color backColor;
  final int campaignId;
  // final String imageUrl;
  // final Media media;
  final String name;
  // final ActionType action;
  final int actionQty;
  final int totalAction;
  // final int costPerAction;
  final int actionPending;
  final DateTime date;

  SocialMediaTile({
    this.backColor,
    this.campaignId,
    // this.imageUrl,
    // this.media,
    this.name,
    // this.action,
    this.actionQty,
    this.totalAction,
    // this.costPerAction,
    this.actionPending,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () => Navigator.pushNamed(context, MyCampaignDetails.id,
              arguments: campaignId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 110,
            color: totalAction == actionQty
              ? Colors.green.withOpacity(0.2)
              : actionPending > 0
                ? Colors.red.withOpacity(0.2)
                : Colors.transparent,
            // backColor,
            child: ShadowBox(
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$name',
                      // '$mediaString :  $name',
                      style: Theme.of(context).textTheme.headline1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat.yMMMd().format(date).toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          mediaString,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  totalAction == actionQty
                    ? Expanded(
                      child: Text(
                        'Done',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // 'Target: $actionQty',
                                '$actionString: $totalAction / $actionQty',
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                actionToIcon,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            // 'Expense: $costPerAction',
                            'Pending: $actionPending',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
       CustomDivider(),
      ],
    );
  }
}
